class CreateConvo < ActiveRecord::Migration
  def self.up
    create_table :convos do |t|
      t.string :title, :null => false, :limit => 140
      t.boolean :private, :default => false
      
      t.timestamps
    end
    add_index :convos, :private
    add_index :convos, :created_at
    
  end

  def self.down
    drop_table :convos
  end
end
