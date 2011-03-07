class Contact < ActiveRecord::Base
  include CohortModelExtensions

  acts_as_taggable

  include TaggingExtensions

  belongs_to :user
  
  has_many :addresses, :dependent => :destroy, :order => :id
  has_many :emails, :dependent => :destroy, :order => :id
  has_many :log_items, :dependent => :destroy, :order => :created_at
  has_many :notes, :dependent => :destroy, :order => :created_at

  def self.per_page
    25
  end

  def hierarchical_tags_for_edit
    ''
  end

  def hierarchical_tag_list
    tags.collect{|t|t.hierarchical_name(' :: ')}.join(', ')
  end

  def hierarchical_tag_list=(tags_to_set)
    split_tags = tags_to_set.split(/,/)
    taggings_to_add = []
    split_tags.each do |t|
      logger.warn("Split tag: #{t}")
      next if t.blank?
      parent_tag = nil
      t.split("::").each do|subtag|
        logger.warn("Subtag: #{subtag}")
        logger.warn('Parent tag:' +  parent_tag.inspect)
        next if subtag.blank?
        #So we need to start from the parent and iterate upwards.
        # If the tag exists and at this level, don't do anything.
        # FIXME - make this work properly with null
        current_tag = ActsAsTaggableOn::Tag.first(:conditions => ['lower(name) = ? and ancestry = ?', subtag.strip.downcase,((parent_tag.blank?) ? nil : parent_tag.ancestry)])
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
      taggings_to_add << ActsAsTaggableOn::Tagging.new(:tag => parent_tag, :taggable => self, :context => 'tags' )
    end
    self.taggings = taggings_to_add
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
