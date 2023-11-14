class CreateTagProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_profiles do |t|
      t.integer :tag_id, null: false, foreign_key: { to_table: :tag}, index: true
      t.integer :profile_id, null: false, foreign_key: { to_table: :profile}, index: true

      t.timestamps
    end
  end
end
