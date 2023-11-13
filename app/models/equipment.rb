# == Schema Information
#
# Table name: equipment
#
#  id         :integer          not null, primary key
#  limits     :integer
#  slot       :integer
#  weapon     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer          not null
#
# Indexes
#
#  index_equipment_on_model_id  (model_id)
#  index_equipment_on_weapon    (weapon)
#
class Equipment < ApplicationRecord
end
