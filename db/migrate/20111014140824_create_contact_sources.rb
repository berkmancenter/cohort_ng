class CreateContactSources < ActiveRecord::Migration
  def self.up
    create_table :contact_sources do |t|
      t.references :contact_cart
      t.string :contact_input_type, :limit => 255
      t.integer :contact_input_id

      t.timestamps
    end

    [:contact_cart_id, :contact_input_type, :contact_input_id].each do|col|
      add_index :contact_sources, col
    end

    add_index :contact_sources, [:contact_cart_id, :contact_input_type, :contact_input_id], :unique => true
  end

  def self.down
    drop_table :contact_sources
  end
end
