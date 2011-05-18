class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :limit => 128
      t.database_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.encryptable

      t.integer :subscriptions_count, :default => 0

      t.timestamps
    end

    add_index :users, :username
    add_index :users, :email
    add_index :users, :confirmation_token
    add_index :users, :reset_password_token
    add_index :users, :created_at
  end

  def self.down
    drop_table :users
  end
end
