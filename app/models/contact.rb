class Contact < ActiveRecord::Base
  include CohortModelExtensions
  include TaggingExtensions
  belongs_to :user
  
  has_many :addresses, :dependent => :destroy
  has_many :emails, :dependent => :destroy
  has_many :log_items, :dependent => :destroy
  has_many :notes, :dependent => :destroy

  accepts_nested_attributes_for :emails,
    :allow_destroy => true,
    :reject_if => proc {|att|
      #if the email is blank OR doesn't match the regex OR the email_type isn't in our list of accepted types, ixnay it.
      if att['email'].blank? || ! att['email'].match(Email::EMAIL_REGEX) || ! Email::EMAIL_TYPES.keys.include?(att['email_type'])
        true
      end
    }

  scope :active, :conditions => {:active => true, :deleted => false}

  def to_s
    "#{(first_name.blank?) ? '' : first_name + ' '}#{last_name}"
  end
   
end
