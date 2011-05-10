class CreateInvitation < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.references :convo, :null => false
      t.references :user, :null => false
      t.integer :requestor_id, :null => false
      
      t.timestamps
    end
    add_index :invitations, :convo_id
    add_index :invitations, :user_id
    add_index :invitations, :requestor_id
    add_index :invitations, :created_at
    
  end

  def self.down
    drop_table :invitations
  end
end
