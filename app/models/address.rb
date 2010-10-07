class Address
  include MongoMapper::EmbeddedDocument
  key :address_1, String, :required => true
  key :address_2, String
  key :city, String, :required => true
  key :state, String
  key :postal_code, String
  key :country, :string, :required => true
  key :updated_at, Time
  key :created_at, Time
end
