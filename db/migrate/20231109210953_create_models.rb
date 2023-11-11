class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :models do |t|
      t.integer :unit, null: false, foreign_key: true
      t.integer :movement
      t.integer :toughness
      t.integer :save_value
      t.integer :wounds
      t.integer :leadership
      t.integer :objective_control
      t.integer :invulnerable_save

      t.timestamps
    end
  end
end
