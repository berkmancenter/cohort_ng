class Document < ActiveRecord::Base
  include CohortModelExtensions
  DOCUMENT_TYPES = {'' => '-- Choose one --','general' => 'General', 'profile_photo' => 'Profile Photo', 'pgp_public_key' => 'PGP Public key', 'ssh_public_key' => 'SSH public key'}

  belongs_to :user, :validate => true
  belongs_to :contact, :validate => true
  validates_inclusion_of :document_type, :in => DOCUMENT_TYPES.keys
  mount_uploader :file_attachment, FileAttachmentUploader

  after_initialize do

    if is_displayable_image?
      FileAttachmentUploader.instance_eval do
        version :thumb do
          process :resize_and_pad => [100,100]
        end
      end
    end

  end
  
  
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

  def is_displayable_image?
    ['png','jpg','jpeg','gif'].include?(self.file_attachment.file.extension)
  end

end
