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
class Model < ApplicationRecord
  belongs_to :unit, class_name: "Unit", counter_cache: true
  has_many :equipments
end
