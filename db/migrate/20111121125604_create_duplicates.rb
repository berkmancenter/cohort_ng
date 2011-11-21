class CreateDuplicates < ActiveRecord::Migration
  def self.up
    create_table :duplicates do |t|
      t.references :user
      t.integer :source_contact_id
      t.references :contact
      t.string :reason, :limit => 100
      t.integer :probability
      t.timestamps
    end

    [:user_id, :source_contact_id, :contact_id, :reason, :probability].each do|col|
      add_index :duplicates, col
    end

  end

  def self.down
    drop_table :duplicates
    drop_table :contacts_duplicates
  end

end
