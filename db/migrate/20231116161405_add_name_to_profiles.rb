class AddNameToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :name, :string
  end
end
