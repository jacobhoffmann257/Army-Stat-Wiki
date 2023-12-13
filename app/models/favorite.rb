# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unit_id    :integer
#  user_id    :integer
#
class Favorite < ApplicationRecord

  belongs_to :unit, required: true, class_name: "Unit", foreign_key: "unit_id"
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
