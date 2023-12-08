class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.integer :weapon_id, null: false, foreign_key: { to_table: :weapons}, index: true
      t.string :attacks
      t.integer :skill
      t.integer :strength
      t.integer :aarmor_piercing
      t.string :damage

      t.timestamps
    end
  end
end
