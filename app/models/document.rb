class Document < ActiveRecord::Base
  include CohortModelExtensions
  DOCUMENT_TYPES = {'general' => 'General', 'profile_photo' => 'Profile Photo', 'pgp_public_key' => 'PGP Public key', 'ssh_public_key' => 'SSH public key'}

  belongs_to :user, :validate => true
  belongs_to :contact, :validate => true
  validates_inclusion_of :document_type, :in => DOCUMENT_TYPES.keys
  mount_uploader :file_attachment, FileAttachmentUploader
  
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

  def to_s
    "#{document_type}, #{name}"
  end

end
