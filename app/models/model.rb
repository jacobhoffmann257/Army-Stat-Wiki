# == Schema Information
#
# Table name: models
#
#  id                :integer          not null, primary key
#  invulnerable_save :integer
#  leadership        :integer
#  movement          :integer
#  name              :string
#  objective_control :integer
#  save_value        :integer
#  toughness         :integer
#  wounds            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  unit_id           :integer          not null
#
# Indexes
#
#  index_models_on_unit_id  (unit_id)
#
class Model < ApplicationRecord
  validates :name, uniqueness: { scope: :unit_id }
  belongs_to :unit, class_name: "Unit"
  has_many :equipments, class_name: "Equipment"
  #has_and_belongs_to_many :weapon, join_table: 'equipment'
 #has_many :melee_weapons, through: :melee_weapons, class_name: "Equipment"
end
