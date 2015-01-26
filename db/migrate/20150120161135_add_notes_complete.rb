class AddNotesComplete < ActiveRecord::Migration
  def self.up
    add_column :notes, :complete, :boolean
  end

  def self.down
    remove_column :notes, :complete
  end
end
