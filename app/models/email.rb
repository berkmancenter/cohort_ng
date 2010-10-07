class Email
  include MongoMapper::EmbeddedDocument
  key :email, String, :required => true
  key :email_type, String, :required => true, :default => 'Work'
  key :is_primary, Boolean
  key :updated_at, Time
  key :created_at, Time
end