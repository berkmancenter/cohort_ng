class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.references :contact
      t.string :phone, :limit => 25, :null => false
      t.string :phone_type, :limit => 50, :default => 'unknown'
      t.boolean :is_primary, :null => true

      t.timestamps
    end
    [:contact_id, :phone_type, :is_primary].each do |col|
      add_index :phone_numbers, col
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end
