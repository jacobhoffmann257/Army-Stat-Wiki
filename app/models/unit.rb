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
end
