class Email < ActiveRecord::Base

  EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  EMAIL_TYPES = {'unknown' => 'Unknown', 'personal' => 'Personal', 'work' => 'Work'}

  belongs_to :contact, :validate => true
  validates_inclusion_of :email_type, :in => EMAIL_TYPES.keys

  validates_format_of :email, :with => EMAIL_REGEX

  def self.email_type_options_for_select
    options = []
    EMAIL_TYPES.keys.each{|type|
      options << [EMAIL_TYPES[type], type]
    }
    return options
  end

end
