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

  def hierarchical_tag_list
    tags.collect{|t|t.hierarchical_name}.join(', ')
  end

  def hierarchical_tag_list=(tags_to_set)
    split_tags = tags_to_set.split(/, /)
    taggings_to_add = []
    split_tags.each do |t|
      taggings_to_add << ActsAsTaggableOn::Tagging.new(:tag => ActsAsTaggableOn::Tag.first( :conditions => {:name => t.split(/ : /)[-1]}), :taggable => self, :context => 'tags' )
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
