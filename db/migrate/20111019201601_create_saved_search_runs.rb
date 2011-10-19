class CreateSavedSearchRuns < ActiveRecord::Migration
  def self.up
    create_table :saved_search_runs do |t|
      t.references :saved_search

      t.timestamps
    end
    add_index :saved_search_runs, :saved_search_id
  end

  def self.down
    drop_table :saved_search_runs
  end
end
