class ChangeNotesTextField < ActiveRecord::Migration
  def self.up
    change_column :notes, :note, :string, :null => false, :limit => 12.kilobytes
  end

  def self.down
    change_column :notes, :note, :string, :null => false, :limit => 4.kilobytes
  end
end
