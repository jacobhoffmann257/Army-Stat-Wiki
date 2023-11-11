# == Schema Information
#
# Table name: models
#
#  id                :integer          not null, primary key
#  invulnerable_save :integer
#  leadership        :integer
#  movement          :integer
#  objective_control :integer
#  save_value        :integer
#  toughness         :integer
#  unit              :integer          not null
#  wounds            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Model < ApplicationRecord
end
