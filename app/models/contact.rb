class Contact < ActiveRecord::Base
  include CohortModelExtensions

  acts_as_taggable
  acts_as_authorization_object

  include TaggingExtensions
  
  has_many :addresses, :dependent => :destroy, :order => :id
  has_many :emails, :dependent => :destroy, :order => :id
  has_many :log_items, :dependent => :destroy, :order => :created_at
  has_many :notes, :dependent => :destroy, :order => :created_at
  has_many :documents, :dependent => :destroy, :order => :created_at

  searchable(:include => [:addresses, :emails, :notes, :tags]) do
    text :first_name, :boost => 2
    text :last_name, :boost => 2
    text :notes
    text :hierarchical_tag_list
    integer :tag_ids, :multiple => true
    string :hierarchical_tag_list
    string :hierarchical_tags, :multiple => true
    time :birthday
    boolean :active
    boolean :deleted
  end

  def self.per_page
    25
  end

  def hierarchical_tags
    tags.collect{|t| t.hierarchical_name(' :: ')}
  end

  def hierarchical_tags_for_edit
    ''
  end

  def hierarchical_tag_list
    tags.collect{|t|t.hierarchical_name(' :: ')}.join(', ')
  end

  def hierarchical_tag_list=(tags_to_set)
    split_tags = tags_to_set.split(/,/)
    tags_to_add = []
    split_tags.each do |t|
      t = t.strip
      logger.warn("Split tag: #{t}")
      next if t.blank?
      parent_tag = nil
      t.split("::").each do|subtag|
        subtag = subtag.strip
        next if subtag.blank?
        logger.warn("Subtag: #{subtag}")
        logger.warn('Parent tag:' +  parent_tag.inspect)
        #So we need to start from the parent and iterate upwards.
        # If the tag exists and at this level, don't do anything.
        # I get that this looks verbose - but apparently using the "lower" function as a key makes ActiveRecord
        # quote the column name incorrectly.

        conditions = ['lower(name) = ?' ]
        values = [subtag.strip.downcase]
        if parent_tag.nil?
          logger.warn('SRSLY - parent tag is null? ' + parent_tag.inspect)
          conditions << 'ancestry is ?'
          values << nil
        else
          logger.warn('parent tag is not null: ' + parent_tag.inspect)
          conditions << 'ancestry = ?'
          values << parent_tag.path_ids.join('/')
        end
        current_tag = ActsAsTaggableOn::Tag.first(:conditions => [conditions.join(' AND '), values].flatten)

        # It doesn't exist. Create it.
        logger.warn('current tag according to find' + current_tag.inspect)
        if current_tag.blank?
          logger.warn('current tag does not exist')
          current_tag = ActsAsTaggableOn::Tag.create(:name => subtag.strip, :parent => parent_tag)
        end
        logger.warn('current tag: ' +  current_tag.inspect)
        parent_tag = current_tag
        logger.warn('current tag at end of loop: ' +  current_tag.inspect)
      end
      tags_to_add <<  parent_tag
    end

    #So technically this re-creates the taggings on each save. This means each save that invokes this method increments the IDs in the taggings table.
    tags_to_add = tags_to_add.uniq.compact
    self.taggings = tags_to_add.collect{|t| ActsAsTaggableOn::Tagging.new(:tag => t, :taggable => self, :context => 'tags')}
  end

  accepts_nested_attributes_for :emails,
    :allow_destroy => true,
    :reject_if => proc {|att|
      #if the email is blank OR doesn't match the regex OR the email_type isn't in our list of accepted types, ixnay it.
      if att['email'].blank? || ! att['email'].match(Email::EMAIL_REGEX) || ! Email::EMAIL_TYPES.keys.include?(att['email_type'])
        true
      end
    }

  accepts_nested_attributes_for :addresses,
    :allow_destroy => true,
    :reject_if => proc {|att|
    if att['address_1'].blank? || att['country'].blank?
      true
    end
  }

  accepts_nested_attributes_for :notes,
    :allow_destroy => true,
    :reject_if => proc {|att|
    if att['note'].blank? 
      true
    end
  }

  scope :active, :conditions => {:active => true, :deleted => false}

  def to_s
    "#{(first_name.blank?) ? '' : first_name + ' '}#{last_name}"
  end
   
end
