# == Schema Information
#
# Table name: profiles
#
#  id             :integer          not null, primary key
#  armor_piercing :integer
#  attacks        :string
#  damage         :string
#  name           :string
#  skill          :integer
#  strength       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  weapon_id      :integer          not null
#
# Indexes
#
#  index_profiles_on_weapon_id  (weapon_id)
#
class Profile < ApplicationRecord
  belongs_to :weapon
end
