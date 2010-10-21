class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :limit => 50, :null => false
      t.string :first_name, :limit => 100
      t.string :last_name, :limit => 100
      t.string :email, :limit => 120, :null => false
      t.string :crypted_password, :limit => 100
      t.string :password_salt, :limit => 100
      t.string :persistence_token
      t.integer :login_count
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip, :limit => 50
      t.string :current_login_ip, :limit => 50

      t.timestamps
    end
    [:login, :email, :persistence_token, :last_request_at, :last_login_at, :current_login_at, :last_login_ip, :current_login_ip].each do |col|
      add_index :users, col
    end
  end

  def self.down
    drop_table :users
  end
end
