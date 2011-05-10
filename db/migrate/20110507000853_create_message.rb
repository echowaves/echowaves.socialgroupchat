class CreateMessage < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :uuid, :null => false, :limit => 255
      t.string :body, :null => false, :limit => 256000
      
      t.references :owner, :null => false  
      t.references :convo, :null => false
      
      t.timestamps
    end
    add_index :messages, :owner_id
    add_index :messages, :convo_id
    add_index :messages, :created_at
    
  end

  def self.down
    drop_table :messages
  end
end
