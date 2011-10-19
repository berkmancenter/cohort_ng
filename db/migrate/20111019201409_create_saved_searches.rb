class CreateSavedSearches < ActiveRecord::Migration
  def self.up
    create_table :saved_searches do |t|
      t.string :name, :null => false, :limit => 255
      t.string :description, :limit => 1.kilobyte
      t.string :search_url, :limit => 2.kilobytes
      t.boolean :global, :default => true

      t.timestamps
    end
    [:name, :search_url, :global].each do|col|
      add_index :saved_searches, col
    end
  end

  def self.down
    drop_table :saved_searches
  end
end
