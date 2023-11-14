# == Schema Information
#
# Table name: unit_keywords
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  keyword_id :integer          not null
#  unit_id    :integer          not null
#
# Indexes
#
#  index_unit_keywords_on_keyword_id  (keyword_id)
#  index_unit_keywords_on_unit_id     (unit_id)
#
class UnitKeyword < ApplicationRecord
end
