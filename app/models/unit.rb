# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  captain    :boolean
#  cost       :integer
#  damage     :boolean
#  dmg_amount :integer
#  max_size   :integer
#  min_size   :integer
#  name       :string
#  picture    :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faction_id :integer          not null
#
# Indexes
#
#  index_units_on_faction_id  (faction_id)
#
class Unit < ApplicationRecord
end
