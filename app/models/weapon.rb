# == Schema Information
#
# Table name: weapons
#
#  id         :integer          not null, primary key
#  name       :string
#  range      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Weapon < ApplicationRecord
  has_many :equipment, class_name: "Equipment", foreign_key: "weapon_id", dependent: :destroy
  has_many :profile
  #scope :melee, -> { where range: 0 }
  #scope :melee_weapons, -> { equipment.where(range: 0)}
  #scope :range_weapons, -> { Weapon.where("range > ? ", 0) }
end
