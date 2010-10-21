class CreateLogItems < ActiveRecord::Migration
  def self.up
    create_table :log_items do |t|
      t.string :log_item_type, :limit => 100, :default => 'update'
      t.text :log_entry, :limit => 4.kilobytes, :null => false
      t.references :user
      t.references :contact
      t.timestamps
    end

    [:user_id,:contact_id,:log_item_type].each do|col|
      add_index :log_items, col
    end

  end

  def self.down
    drop_table :log_items
  end
end
