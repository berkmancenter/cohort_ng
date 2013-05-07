class Contact < ActiveRecord::Base
  include CohortModelExtensions

  acts_as_taggable
  acts_as_authorization_object

  include TaggingExtensions
  
  has_many :addresses, :dependent => :destroy, :order => :id
  has_many :emails, :dependent => :destroy, :order => :id
  has_many :phone_numbers, :dependent => :destroy, :order => :id
  has_many :log_items, :dependent => :destroy, :order => :created_at
  has_many :notes, :dependent => :destroy, :order => :created_at
  has_many :documents, :dependent => :destroy, :order => :created_at
  
  validates_presence_of :first_name, :last_name

  accepts_nested_attributes_for :emails,
    :allow_destroy => true,
    :reject_if => proc {|att|
    #if the email is blank OR doesn't match the regex OR the email_type isn't in our list of accepted types, ixnay it.
    if att['email'].blank? || ! att['email'].match(Email::EMAIL_REGEX) || ! Email::EMAIL_TYPES.keys.include?(att['email_type'])
      true
    end
  }

  accepts_nested_attributes_for :phone_numbers,
    :allow_destroy => true,
    :reject_if => proc {|att|
    if att['phone'].blank? 
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

  scope :by_email,
    lambda{|email_to_find|
    select('DISTINCT contacts.*').joins(:emails).where(['lower(emails.email) = ?', email_to_find.downcase])
  }

  def self.bulk_updateable_columns
    ['first_name','last_name','birthday','title']
  end

  def self.find_or_init_by_email(email)
    new_contact = self.by_email(email)
    (new_contact.blank?) ? Contact.new : new_contact.first
  end

  def self.per_page
    25
  end

  def first_name_downcase
    self.first_name.downcase
  end

  def last_name_downcase
    self.last_name.downcase
  end

  def notes_for_indexing
    self.notes.collect{|n| n.note.downcase}
  end

  def documents_for_indexing
    self.documents.collect{|d| [d.name.to_s.downcase, d.content.to_s.downcase, d.file_name.to_s.downcase].join(' ')}
  end

  def organizations
    organization_root_tag_id = CohortNg::Application.config.organization_root_tag.id
    organizations = ActsAsTaggableOn::Tag.search do
      all_of do
        with :id, self.tag_ids
        with :ancestor_ids, organization_root_tag_id
      end
    end
    organizations.execute
    organizations.results
  end

  searchable(:include => [:addresses, :emails, :notes, :tags, :documents]) do
    text :first_name_downcase, :boost => 2, :more_like_this => true
    text :last_name_downcase, :boost => 2, :more_like_this => true
    text :notes_for_indexing
    text :documents_for_indexing
    text :hierarchical_tag_list
    text :email_addresses_as_string, :more_like_this => true
    text :phone_numbers_for_indexing

    string :first_name_downcase
    string :last_name_downcase
    string :email_addresses, :multiple => true
    string :phone_numbers_for_indexing, :multiple => true
    string :notes_for_indexing, :multiple => true

    integer :tag_ids, :multiple => true
    string :hierarchical_tag_list
    string :hierarchical_tags, :multiple => true
    time :birthday
    time :updated_at
    time :created_at
    boolean :active
    boolean :deleted
  end

  def phone_numbers_for_indexing
    self.phone_numbers.collect{|p| p.phone}
  end


  def email_addresses
    self.emails.collect{|e| e.email.downcase}
  end

  def email_addresses_as_string
    self.email_addresses.join(' ')
  end

  def contacts
    [self]
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
      #logger.warn("Split tag: #{t}")
      next if t.blank?
      parent_tag = nil
      t.split("::").each do|subtag|
        subtag = subtag.strip
        next if subtag.blank?
        #logger.warn("Subtag: #{subtag}")
        #logger.warn('Parent tag:' +  parent_tag.inspect)
        #So we need to start from the parent and iterate upwards.
        # If the tag exists and at this level, don't do anything.
        # I get that this looks verbose - but apparently using the "lower" function as a key makes ActiveRecord
        # quote the column name incorrectly.

        conditions = ['lower(name) = ?' ]
        values = [subtag.strip.downcase]
        if parent_tag.nil?
          #logger.warn('SRSLY - parent tag is null? ' + parent_tag.inspect)
          conditions << 'ancestry is ?'
          values << nil
        else
          #logger.warn('parent tag is not null: ' + parent_tag.inspect)
          conditions << 'ancestry = ?'
          values << parent_tag.path_ids.join('/')
        end
        current_tag = ActsAsTaggableOn::Tag.first(:conditions => [conditions.join(' AND '), values].flatten)

        # It doesn't exist. Create it.
        #logger.warn('current tag according to find' + current_tag.inspect)
        if current_tag.blank?
          #logger.warn('current tag does not exist')
          current_tag = ActsAsTaggableOn::Tag.create(:name => subtag.strip, :parent => parent_tag)
        end
        #logger.warn('current tag: ' +  current_tag.inspect)
        parent_tag = current_tag
        #logger.warn('current tag at end of loop: ' +  current_tag.inspect)
      end
      tags_to_add <<  parent_tag
    end

    #So technically this re-creates the taggings on each save. This means each save that invokes this method increments the IDs in the taggings table.
    tags_to_add = tags_to_add.uniq.compact
    self.taggings = tags_to_add.collect{|t| ActsAsTaggableOn::Tagging.new(:tag => t, :taggable => self, :context => 'tags')}
  end


  def to_s
    "#{(first_name.blank?) ? '' : first_name + ' '}#{last_name}"
  end
   
end
