# == Schema Information
#
# Table name: weapons
#
#  id         :integer          not null, primary key
#  name       :string
#  range      :integer
#  skill      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Weapon < ApplicationRecord
  validates :name, uniqueness: { scope: [:range, :skill] }
  has_many :equipment, class_name: "Equipment", foreign_key: "weapon_id", dependent: :destroy
  has_many :profile
  def get_profiles 
     profile_array = Array.new 
      self.profile.each do |profile| 
        if !profile_array.include?(profile) 
          profile_array.push(profile) 
        end 
      end
      return profile_array
  end
  #scope :melee, -> { where range: 0 }
  #scope :melee_weapons, -> { equipment.where(range: 0)}
  #scope :range_weapons, -> { Weapon.where("range > ? ", 0) }
end
