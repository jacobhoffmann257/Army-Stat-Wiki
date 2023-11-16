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
#  unit_it           :integer          not null
#  wounds            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Model < ApplicationRecord
end
