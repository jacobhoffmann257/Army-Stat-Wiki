class ChangeBaseToString < ActiveRecord::Migration[7.0]
  def change
    change_column :units, :base_size, :string
  end
end
