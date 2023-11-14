class CreateUnitAbilities < ActiveRecord::Migration[7.0]
  def change
    create_table :unit_abilities do |t|
      t.integer :unit_id, null: false, foreign_key: { to_table: :unit}, index: true
      t.integer :ability_id, null: false, foreign_key: { to_table: :ability}, index: true

      t.timestamps
    end
  end
end
