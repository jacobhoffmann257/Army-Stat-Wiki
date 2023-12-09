class CreateFactions < ActiveRecord::Migration[7.0]
  def change
    create_table :factions do |t|
      t.string :name, presence: true 
      t.string :banner
      t.string :icon
      t.string :picture

      t.timestamps
    end
  end
end
