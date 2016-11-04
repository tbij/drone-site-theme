
class Location < ApplicationRecord
  belongs_to :country
  has_many :strikes

  geocoded_by :description   # can also be an IP address
end