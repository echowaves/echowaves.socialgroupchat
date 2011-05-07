class CreateSubscription < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.references :user
      t.references :convo

      t.integer :last_read_message_id
      t.integer :new_messages_count

      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :convo_id
    add_index :subscriptions, :created_at
    
  end

  def self.down
    drop_table :subscriptions
  end
end
