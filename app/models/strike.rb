# == Schema Information
#
# Table name: strikes
#
#  id                       :integer          not null, primary key
#  country_id               :integer
#  strike_id                :string
#  date                     :date
#  location                 :string
#  minimum_people_killed    :integer
#  maximum_people_killed    :integer
#  minimum_civilians_killed :integer
#  maximum_civilians_killed :integer
#  minimum_children_killed  :integer
#  maximum_children_killed  :integer
#  minimum_people_injured   :integer
#  maximum_people_injured   :integer
#  latitude                 :float
#  longitude                :float
#  index                    :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Strike < ApplicationRecord
  belongs_to :country
  belongs_to :location
  scope :group_by_month,   -> { group("date_trunc('month', date) ") }
end
