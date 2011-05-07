class CreateMessage < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :uuid, :null => false
      t.string :body,:null => false
      
      t.timestamps
    end
    add_index :messages, :created_at
    
  end

  def self.down
    drop_table :messages
  end
end
