class AddWebsiteContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :website, :string
    add_column :contacts, :twitter, :string
    add_column :contacts, :facebook, :string
    add_column :contacts, :linkedin, :string
  end

  def self.down
    remove_column :contacts, :website
    remove_column :contacts, :twitter
    remove_column :contacts, :facebook
    remove_column :contacts, :linkedin
  end
end
