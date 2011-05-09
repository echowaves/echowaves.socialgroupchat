class CreateVisit < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.references :user, :null => false
      t.references :convo, :null => false
      t.integer :visits_count, :null => false, :default => 1
      
      t.timestamps
    end
    add_index :visits, :user_id
    add_index :visits, :convo_id
    add_index :visits, :created_at
    
    
  end

  def self.down
    drop_table :visits
  end
end
