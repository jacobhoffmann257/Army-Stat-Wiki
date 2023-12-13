# == Schema Information
#
# Table name: factions
#
#  id         :integer          not null, primary key
#  banner     :string
#  color      :string
#  icon       :string
#  name       :string
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Faction < ApplicationRecord
  validates :name, uniqueness: true
 
  has_many :unit

  def get_units
    unit_array = Array.new
    self.unit.each do |unit|
      if !unit_array.include?(unit)
        unit_array.push(unit)
      end
    end
    return unit_array
  end
  def get_units_by_class (type)
    unit_array = Array.new
    self.unit.each do |unit|
      if unit.role === type
        unit_array.push(unit)
      end
    end
    return unit_array
  end
end
