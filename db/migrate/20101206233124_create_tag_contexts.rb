class CreateTagContexts < ActiveRecord::Migration
  def self.up
    create_table :tag_contexts do |t|
      t.string :name, :limit => 50, :null => false
      t.string :context, :limit => 50, :null => false
      t.string :object_tagged, :limit => 50, :default => 'Contact'
      t.string :description, :limit => 10.kilobytes
      t.integer :position, :default => 1
      t.timestamps
    end
    [:name, :context, :object_tagged, :position].each do|col|
      add_index :tag_contexts, col
    end
    add_index :tag_contexts, [:context, :object_tagged], :unique => true
  end

  def self.down
    drop_table :tag_contexts
  end
end
