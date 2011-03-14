class Document < ActiveRecord::Base
  include CohortModelExtensions

  DOCUMENT_TYPES = {'general' => 'General', 'profile_photo' => 'Profile Photo', 'pgp_public_key' => 'PGP Public key', 'ssh_public_key' => 'SSH public key'}
  
  def self.per_page
    25
  end
  
  def self.document_type_options_for_select
    options = []
    DOCUMENT_TYPES.keys.each{|type|
      options << [DOCUMENT_TYPES[type], type]
    }
    return options
  end

end
