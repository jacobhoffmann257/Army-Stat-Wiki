class CreateWeapons < ActiveRecord::Migration[7.0]
  def change
    create_table :weapons do |t|
      t.string :name, null: :false
      t.integer :range

      t.timestamps
    end
  end
end
