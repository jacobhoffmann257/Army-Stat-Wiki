class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :equipment do |t|
      t.integer :model_id, null: false, foreign_key: { to_table: :models}, index: true
      t.integer :weapon, null: false, foreign_key: { to_table: :weapons}, index: true
      t.integer :limits
      t.integer :slot

      t.timestamps
    end
  end
end
