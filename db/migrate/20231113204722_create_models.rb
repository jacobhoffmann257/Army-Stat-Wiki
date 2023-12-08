class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :models do |t|
      t.integer :movement, null: :false
      t.integer :toughness, null: :false
      t.integer :save_value, null: :false
      t.integer :invulnerable_save, null: :false
      t.integer :wounds, null: :false
      t.integer :leadership, null: :false
      t.integer :objective_control, null: :false
      t.integer :unit_id, null: false, foreign_key: { to_table: :unit}, index: true
      t.string :name, null: :false

      t.timestamps
    end
  end
end
