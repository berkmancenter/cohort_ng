class Contact
  include MongoMapper::Document

  key :first_name, String, :required => true
  key :last_name, String, :required => true
  key :birthday, Time, :default => nil
  key :active, Boolean, :default => true
  key :updated_at, Time
  key :created_at, Time
  key :user_id, ObjectId

  many :addresses
  many :emails
  many :log_items
  many :notes

  before_create {|c| c.created_at = c.updated_at = Time.now }
  before_save {|c| c.updated_at = Time.now }
   
end
