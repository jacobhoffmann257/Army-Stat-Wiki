class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :equipment do |t|
      t.integer :model_id, null: false, foreign_key: { to_table: :models }
      t.integer :weapon_id, null: false, foreign_key: { to_table: :weapons }
      t.integer :limits
      t.integer :slot

      t.timestamps
    end
  end
end
