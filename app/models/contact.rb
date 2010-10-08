class Contact
  include MongoMapper::Document
  include CohortModelExtensions

  key :first_name, String, :required => true, :index => true
  key :last_name, String, :required => true, :index => true
  key :birthday, Time, :default => nil, :index => true
  key :active, Boolean, :default => true, :index => true
  key :updated_at, Time, :index => true
  key :created_at, Time, :index => true
  key :user_id, ObjectId, :index => true

  many :addresses
  many :emails
  many :log_items
  many :notes

#  before_create {|c| c.created_at = c.updated_at = Time.now }
#  before_save {|c| c.updated_at = Time.now }
   
end
