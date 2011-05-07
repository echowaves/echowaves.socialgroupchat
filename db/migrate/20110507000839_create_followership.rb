class CreateFollowership < ActiveRecord::Migration
  def self.up
    create_table :followerships do |t|
      t.references :user
      t.integer :follower_id
            
      t.timestamps
    end
    add_index :followerships, :user_id
    add_index :followerships, :follower_id
    add_index :followerships, :created_at
    
  end

  def self.down
    drop_table :followerships
  end
end
