class PhoneNumber < ActiveRecord::Base
  PHONE_TYPES = {'unknown' => 'Unknown', 'personal' => 'Personal', 'work' => 'Work', 'mobile' => 'Mobile', 'fax' => 'Fax'}

  belongs_to :contact, :validate => true
  validates_inclusion_of :phone_type, :in => PHONE_TYPES.keys

  def self.phone_type_options_for_select
    options = []
    PHONE_TYPES.keys.each{|type|
      options << [PHONE_TYPES[type], type]
    }
    return options
  end

end
