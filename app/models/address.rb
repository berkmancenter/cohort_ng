class Address < ActiveRecord::Base
  belongs_to :contact, :validate => true

  ADDRESS_TYPES = {'unknown' => 'Unknown', 'personal' => 'Personal', 'work' => 'Work'}
  validates_inclusion_of :address_type, :in => ADDRESS_TYPES.keys

  def self.address_type_options_for_select
    options = []
    ADDRESS_TYPES.keys.each{|type|
      options << [ADDRESS_TYPES[type], type]
    }
    return options
  end

end
