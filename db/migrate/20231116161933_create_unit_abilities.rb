class CreateUnitAbilities < ActiveRecord::Migration[7.0]
  def change
    create_table :unit_abilities do |t|
      t.integer :unit_id
      t.integer :abilities_id

      t.timestamps
    end
  end
end
