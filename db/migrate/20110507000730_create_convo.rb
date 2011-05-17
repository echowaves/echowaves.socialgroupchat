class CreateConvo < ActiveRecord::Migration
  def self.up
    create_table :convos do |t|
      t.string :title, :limit => 140, null: false
      t.integer :privacy_level, :default => 0, null: false
      t.boolean :read_only, :default => :false, null: false
      
      t.references :owner, :null => false
      
      t.timestamps
    end
    add_index :convos, :privacy_level
    add_index :convos, :created_at
    add_index :convos, :owner_id
    
  end

  def self.down
    drop_table :convos
  end
end
