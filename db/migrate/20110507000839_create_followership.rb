class CreateFollowership < ActiveRecord::Migration
  def self.up
    create_table :followerships do |t|
      t.integer :leader_id
      t.integer :follower_id
            
      t.timestamps
    end
    add_index :followerships, :leader_id
    add_index :followerships, :follower_id
    add_index :followerships, :created_at
    
  end

  def self.down
    drop_table :followerships
  end
end
