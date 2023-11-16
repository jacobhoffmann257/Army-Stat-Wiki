# == Schema Information
#
# Table name: factions
#
#  id         :integer          not null, primary key
#  banner     :string
#  icon       :string
#  name       :string
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Faction < ApplicationRecord
end
