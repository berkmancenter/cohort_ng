class CreateContactCarts < ActiveRecord::Migration
  def self.up
    create_table :contact_carts do |t|
      t.string :name, :limit => 100, :null => false
      t.text :description
      t.references :user
      t.boolean :global, :default => true

      t.timestamps
    end

    [:user_id, :global, :name].each do|col|
      add_index :contact_carts, col
    end

    create_table :contact_carts_contacts, :id => false, :force => true do |t|
      t.references :contact_cart
      t.references :contact
    end

    add_index :contact_carts_contacts, :contact_cart_id

    add_index :contact_carts_contacts, [:contact_id, :contact_cart_id], :unique => true

  end

  def self.down
    drop_table :contact_carts
  end
end
