# == Schema Information
#
# Table name: locations
#
#  id          :integer          not null, primary key
#  country_id  :integer
#  description :string
#  latitude    :float
#  longitude   :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class Location < ApplicationRecord
  belongs_to :country
  has_many :strikes

  geocoded_by :description   # can also be an IP address
end
