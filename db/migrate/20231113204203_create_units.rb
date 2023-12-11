class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :name
      t.integer :faction_id, null: false, foreign_key: { to_table: :faction}, index: true
      t.integer :cost
      t.integer :min_size
      t.integer :max_size
      t.string :role
      t.boolean :damage
      t.integer :dmg_amount
      t.boolean :captain
      t.string :picture
      t.string :base_size

      t.timestamps
    end
  end
end
