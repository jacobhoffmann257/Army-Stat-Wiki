class CreateUnitKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :unit_keywords do |t|
      t.integer :unit_id, null: false, foreign_key: { to_table: :units }, index:true
      t.integer :keyword_id, null: false, foreign_key: { to_table: :keywords }, index:true

      t.timestamps
    end
  end
end
