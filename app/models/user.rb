class User
  include MongoMapper::Document

  key :username, String, :required => true
  key :email, String, :required => true
  key :password_hash, String

  many :notes
  many :groups
  many :contacts

end
