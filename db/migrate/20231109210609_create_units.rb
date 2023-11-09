class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.integer :small
      t.integer :large
      t.integer :faction_id, null: false, foreign_key: true
      t.boolean :captain
      t.integer :damage

      t.timestamps
    end
  end
end
