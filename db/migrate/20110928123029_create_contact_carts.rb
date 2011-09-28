class CreateContactCarts < ActiveRecord::Migration
  def self.up
    create_table :contact_carts do |t|
      t.string :name
      t.description :text
      t.user_id :integer
      t.boolean :global

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_carts
  end
end
