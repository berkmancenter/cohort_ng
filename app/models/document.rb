class Document < ActiveRecord::Base
  include CohortModelExtensions
  DOCUMENT_TYPES = {'' => '-- Choose one --','general' => 'General', 'profile_photo' => 'Profile Photo', 'pgp_public_key' => 'PGP Public key', 'ssh_public_key' => 'SSH public key'}
  acts_as_authorization_object

  scope :for_indexing, where(['needs_indexing is true'])

  belongs_to :contact, :validate => true
  validates_inclusion_of :document_type, :in => DOCUMENT_TYPES.keys
  mount_uploader :file_attachment, FileAttachmentUploader
  
  def self.per_page
    25
  end

  def file_name
    file_attachment.to_s
  end

  searchable do 
    text :content
    text :name, :boost => 2
    text :file_name, :boost => 2

    string :name
    string :file_attachment
  end

  def get_file_contents
    begin
      Open3.popen3('/usr/bin/java', '-jar', "#{RAILS_ROOT}/script/tika-app-0.10.jar", "-t", self.file_attachment.path) do |stdin, stdout, error|
        stdin.close
        stdout.read
      end
    rescue Exception => e
      return nil
    end
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

  def thumb_url(geometry = '150x150', square = false, quality = 85)
    if is_displayable_image?
      geometry.gsub!(/[^\dx]/,'')
      #Sigh. carrierwave will attempt to process ANY attachment. I can't figure out an easy way to make it only process images.
      thumb_location = "#{RAILS_ROOT}/public/images/thumbs/#{geometry}/#{Digest::MD5.hexdigest(self.file_attachment.path)}-#{(square) ? '-square' : ''}-#{quality}.jpg"
      thumb_url = "/images/thumbs/#{geometry}/#{Digest::MD5.hexdigest(self.file_attachment.path)}-#{(square) ? '-square' : ''}-#{quality}.jpg"
      if ! File.exists?(thumb_location)
#        logger.warn('Thumb regen')
        if ! File.exists?("#{RAILS_ROOT}/public/images/thumbs/#{geometry}/")
          FileUtils.mkdir_p("#{RAILS_ROOT}/public/images/thumbs/#{geometry}/")
          FileUtils.chmod 0755, "#{RAILS_ROOT}/public/images/thumbs/#{geometry}/"
        end
        image = MiniMagick::Image.open(self.file_attachment.path)
        
        #the line below was causing: ActionView::Template::Error (can't convert Fixnum into String)
        #image.quality quality
        
        if square
          if image[:width] < image[:height]
            remove = ((image[:height] - image[:width])/2).round
            image.shave "0x#{remove}"
          elsif image[:width] > image[:height]
            remove = ((image[:width] - image[:height])/2).round
            image.shave "#{remove}x0"
          end
          image.resize "#{geometry}x#{geometry}"
        else
          image.resize geometry
        end
        image.write  thumb_location
      else
#        logger.warn('Thumb is cached')
      end
      return thumb_url
    end
    ''
  end

end
