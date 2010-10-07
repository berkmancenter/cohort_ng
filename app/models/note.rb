class Note
  include MongoMapper::Document

  key :contact_id, ObjectId
  key :user_id, ObjectId
  key :note, String, :required => true
  key :updated_at, Time
  key :created_at, Time

  
end
