# == Schema Information
#
# Table name: tag_profiles
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :integer          not null
#  tag_id     :integer          not null
#
# Indexes
#
#  index_tag_profiles_on_profile_id  (profile_id)
#  index_tag_profiles_on_tag_id      (tag_id)
#
class TagProfile < ApplicationRecord
end
