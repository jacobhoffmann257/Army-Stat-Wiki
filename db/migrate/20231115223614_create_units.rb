class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :name, presence: true
      t.string :role
      t.integer :cost
      t.integer :faction_id, null: false, foreign_key: {to_table: :factions}
      t.integer :max_size
      t.string :base_size
      t.string :picture

      t.timestamps
    end
  end
end
