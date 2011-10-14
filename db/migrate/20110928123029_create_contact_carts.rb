class CreateContactCarts < ActiveRecord::Migration
  def self.up
    create_table :contact_carts do |t|
      t.string :name, :limit => 250, :null => false
      t.string :description, :limit => 5.kilobytes
      t.boolean :global, :default => true

      t.timestamps
    end

    [:global, :name].each do|col|
      add_index :contact_carts, col
    end

  end

  def self.down
    drop_table :contact_carts
  end
end
