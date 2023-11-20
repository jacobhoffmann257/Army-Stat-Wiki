# == Schema Information
#
# Table name: abilities
#
#  id             :integer          not null, primary key
#  classification :string
#  description    :text
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Ability < ApplicationRecord
  has_many :unit_abilities
end
