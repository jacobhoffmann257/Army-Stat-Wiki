class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :models do |t|
      t.string :name
      t.integer :unit_it,null: false, foreign_key: { to_table: :units }
      t.integer :movement
      t.integer :toughness
      t.integer :save_value
      t.integer :invulnerable_save
      t.integer :wounds
      t.integer :leadership
      t.integer :objective_control

      t.timestamps
    end
  end
end
