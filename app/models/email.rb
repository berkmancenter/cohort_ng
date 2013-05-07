class Email < ActiveRecord::Base

  EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  EMAIL_TYPES = {'unknown' => 'Unknown', 'personal' => 'Personal', 'work' => 'Work'}

  belongs_to :contact, :validate => true
  validates_presence_of :email
  validates_inclusion_of :email_type, :in => EMAIL_TYPES.keys
  validates_uniqueness_of :email  
  validates_format_of :email, :with => EMAIL_REGEX

  before_validation do |rec|
    rec.email = rec.email.downcase
  end

  def self.email_type_options_for_select
    options = []
    EMAIL_TYPES.keys.each{|type|
      options << [EMAIL_TYPES[type], type]
    }
    return options
  end

end
