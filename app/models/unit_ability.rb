# == Schema Information
#
# Table name: unit_abilities
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ability_id :integer
#  unit_id    :integer
#
class UnitAbility < ApplicationRecord
  belongs_to :unit
  belongs_to :ability
end
