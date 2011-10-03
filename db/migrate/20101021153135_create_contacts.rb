class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :first_name, :limit => 100, :null => false
      t.string :last_name, :limit => 100, :null => false
      t.date :birthday
      t.boolean :active, :default => true
      t.boolean :deleted, :default => false

      t.timestamps
    end
    [:first_name, :last_name, :birthday, :active, :deleted].each do|col|
      add_index :contacts, col
    end
  end

  def self.down
    drop_table :contacts
  end
end
