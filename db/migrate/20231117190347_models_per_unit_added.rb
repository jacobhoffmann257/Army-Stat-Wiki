class ModelsPerUnitAdded < ActiveRecord::Migration[7.0]
  def change
    add_column :units, :models_per_unit, :integer
  end
end
