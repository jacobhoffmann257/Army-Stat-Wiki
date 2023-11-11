# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  captain    :boolean
#  damage     :integer
#  large      :integer
#  small      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faction_id :integer          not null
#
class Unit < ApplicationRecord
end
