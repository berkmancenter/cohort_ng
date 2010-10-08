class Note
  include MongoMapper::Document
  include CohortModelExtensions

  key :contact_id, ObjectId, :index => true
  key :user_id, ObjectId, :index => true
  key :note, String, :required => true
  key :updated_at, Time, :index => true
  key :created_at, Time, :index => true
  
end
