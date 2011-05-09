class CreateMessage < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :uuid, :null => false
      t.string :body,:null => false
      
      t.references :owner, :null => false  
      t.references :convo, :null => false
      
      t.timestamps
    end
    add_index :messages, :created_at
    add_index :messages, :owner_id
    
  end

  def self.down
    drop_table :messages
  end
end
