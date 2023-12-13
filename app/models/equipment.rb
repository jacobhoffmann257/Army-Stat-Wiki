# == Schema Information
#
# Table name: equipment
#
#  id         :integer          not null, primary key
#  limits     :integer
#  slot       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unit_id    :integer          not null
#  weapon_id  :integer          not null
#
# Indexes
#
#  index_equipment_on_unit_id    (unit_id)
#  index_equipment_on_weapon_id  (weapon_id)
#
class Equipment < ApplicationRecord
  validates :unit_id, uniqueness: { scope: [:weapon_id] }
  #validates :name, uniqueness: { scope: [:range, :skill] }
  belongs_to :unit
  belongs_to :weapon

  # has_many :weapon, class_name: "Weapon", foreign_key: "weapon_id"
  
  # has_many :melee_weapon, -> {weapon.select(range: 0)}
  #scope :melee, -> { where range: 0 }
end
