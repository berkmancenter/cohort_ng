class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :address_type, :limit => 20, :default => 'unknown'
      t.string :address_1, :limit => 150
      t.string :address_2, :limit => 150
      t.string :city, :limit => 100
      t.string :state, :limit => 100
      t.string :postal_code, :limit => 30
      t.string :country, :limit => 50, :null => false
      t.references :contact
      t.timestamps
    end
    [:contact_id, :address_1, :city, :state, :postal_code, :country].each do|col|
      add_index :addresses, col
    end
  end

  def self.down
    drop_table :addresses
  end
end
