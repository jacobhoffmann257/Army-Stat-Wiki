# == Schema Information
#
# Table name: bodyguards
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  leader_id  :integer          not null
#  unit_id    :integer          not null
#
# Indexes
#
#  index_bodyguards_on_leader_id  (leader_id)
#  index_bodyguards_on_unit_id    (unit_id)
#
class Bodyguard < ApplicationRecord
end
