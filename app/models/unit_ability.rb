# == Schema Information
#
# Table name: unit_abilities
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ability_id :integer          not null
#  unit_id    :integer          not null
#
# Indexes
#
#  index_unit_abilities_on_ability_id  (ability_id)
#  index_unit_abilities_on_unit_id     (unit_id)
#
class UnitAbility < ApplicationRecord
end
