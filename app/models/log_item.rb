class LogItem
  include MongoMapper::Document

  key :contact_id, ObjectId
  key :user_id, ObjectId
  key :log_entry, String
  key :updated_at, Time
  key :created_at, Time

  
end
