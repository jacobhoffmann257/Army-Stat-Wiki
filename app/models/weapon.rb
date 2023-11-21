# == Schema Information
#
# Table name: weapons
#
#  id         :integer          not null, primary key
#  name       :string
#  range      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Weapon < ApplicationRecord
  has_many :equipment
  has_many :profile
end
