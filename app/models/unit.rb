# == Schema Information
#
# Table name: units
#
#  id              :integer          not null, primary key
#  base_size       :string
#  captain         :boolean
#  cost            :integer
#  damage          :boolean
#  dmg_amount      :integer
#  max_size        :integer
#  min_size        :integer
#  models_per_unit :integer
#  name            :string
#  picture         :string
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  faction_id      :integer          not null
#
# Indexes
#
#  index_units_on_faction_id  (faction_id)
#
class Unit < ApplicationRecord
  validates :name, uniqueness: true
  belongs_to :faction, class_name: "Faction"
  has_many :models, class_name: "Model"
  has_many :equipments, class_name: "Equipment"
  has_many :unit_abilities, class_name: "UnitAbility"
  has_many  :favorites, class_name: "Favorite", foreign_key: "unit_id", dependent: :destroy
  accepts_nested_attributes_for :favorites, allow_destroy: true

  def get_weapons
    # needs to get models and then their weapons and filter out the ones that are duplicates
    range_weapons = Array.new
    melee_weapons = Array.new
    self.equipments.each do |equipment|
      weapon = Weapon.where(id: equipment.weapon_id).last
        if !melee_weapons.include?(weapon) && weapon.range === 0
          melee_weapons.push(weapon)
        elsif !range_weapons.include?(weapon)&& weapon.range != 0
          range_weapons.push(weapon)
        end
    end
    weapons = Array.new
    if range_weapons.length != 0
      weapons.push(range_weapons)
    end
    weapons.push(melee_weapons)
    return weapons
  end
  def get_one_eye
    ooe = Unit.where(name: "Old One Eye").last
    return ooe
  end
  def get_abilities (type)
    unit_abilities = self.unit_abilities
    puts unit_abilities.class
    abilities = Array.new
    unit_abilities.each do |unit_ability|
      ability = Ability.where(id: unit_ability.ability_id).last
      if ability.classification === type
        abilities.push(ability)
      end
    end
    return abilities
  end
end
