class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string :note, :null => false, :limit => 4.kilobytes
      t.string :note_type, :limit => 50, :default => 'general'
      t.datetime :due_date, :default => nil
      t.integer :priority, :default => 50
      t.references :contact

      t.timestamps
    end
    [:contact_id, :note_type, :due_date, :priority].each do |col|
      add_index :notes, col
    end

  end

  def self.down
    drop_table :notes
  end
end
