# == Schema Information
#
# Table name: units
#
#  id              :integer          not null, primary key
#  base_size       :string
#  cost            :integer
#  max_size        :integer
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
  belongs_to :faction, class_name: "Faction"
  has_many :models, class_name: "Model"
  has_many :unit_abilities

  def get_weapons
    # needs to get models and then their weapons and filter out the ones that are duplicates
    models = self.models
    range_weapons = Array.new
    melee_weapons = Array.new
    models.each do |model|
      model.equipments.each do |equipment|
        weapon = Weapon.where(id: equipment.weapon_id).last
        if !melee_weapons.include?(weapon) && weapon.range === 0
          melee_weapons.push(weapon)
        elsif !range_weapons.include?(weapon)&& weapon.range != 0
          range_weapons.push(weapon)
        end
      end
    end
    weapons = Array.new
    if range_weapons.length != 0
      weapons.push(range_weapons)
    end
    weapons.push(melee_weapons)
    return weapons
  end

end
