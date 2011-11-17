class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :email, :limit => 150, :null => false
      t.string :email_type, :limit => 50, :default => 'unknown'
      t.boolean :is_primary, :null => true      
      t.references :contact

      t.timestamps
    end
    [:contact_id, :email_type, :is_primary].each do |col|
      add_index :emails, col
    end
    add_index :emails, :email, :unique => true

  end

  def self.down
    drop_table :emails
  end
end
