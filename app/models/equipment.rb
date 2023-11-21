# == Schema Information
#
# Table name: equipment
#
#  id         :integer          not null, primary key
#  limits     :integer
#  slot       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer          not null
#  weapon_id  :integer          not null
#
class Equipment < ApplicationRecord
  belongs_to :model
  belongs_to :weapon
end
