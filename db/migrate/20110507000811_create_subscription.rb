class CreateSubscription < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.references :user, :null  => false
      t.references :convo, :null => false

      t.integer :last_read_message_id, :null => false
      t.integer :new_messages_count, :null => false, default: 0

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
