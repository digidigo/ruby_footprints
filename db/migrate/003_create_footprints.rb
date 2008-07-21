class CreateFootprints < ActiveRecord::Migration
  def self.up
    create_table :footprints, :force => true do |t|
      t.integer :attacker_id, :null => false
      t.integer :victim_id, :null => false
      t.timestamps
    end
    
    add_index(:footprints, :attacker_id) rescue nil
    add_index(:footprints, :victim_id) rescue nil
  end

  def self.down
    drop_table :footprints
  end
end
