# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  base_size  :string
#  cost       :integer
#  max_size   :integer
#  name       :string
#  picture    :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faction_id :integer          not null
#
class Unit < ApplicationRecord
  belongs_to :faction, class_name: "Faction", counter_cache: true
  has_many :models
  has_many :abilities
end
