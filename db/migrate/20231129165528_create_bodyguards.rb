class CreateBodyguards < ActiveRecord::Migration[7.0]
  def change
    create_table :bodyguards do |t|
      t.integer :leader_id, null: false, foreign_key: { to_table: :unit_abilities }, index:true
      t.integer :unit_id, null: false, foreign_key: { to_table: :units }, index:true

      t.timestamps
    end
  end
end
