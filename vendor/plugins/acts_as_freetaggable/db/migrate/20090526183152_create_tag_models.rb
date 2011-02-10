class CreateTagModels < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|

      t.integer :position
      t.string :ancestry

      t.string :title
      t.string :description
      t.string :tag_path
      t.boolean :removable, :default => true

      t.timestamps
    end
    [:position, :ancestry].each do|col|
      add_index :tags, col
    end

    create_table :taggings do |t|
      t.references :freetaggable, :polymorphic => true
      t.references :tag
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
    drop_table :taggings
  end
end
