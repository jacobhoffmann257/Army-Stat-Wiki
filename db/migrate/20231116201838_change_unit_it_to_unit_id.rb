class ChangeUnitItToUnitId < ActiveRecord::Migration[7.0]
  def change
    rename_column(:models, :unit_it, :unit_id)
  end
end
