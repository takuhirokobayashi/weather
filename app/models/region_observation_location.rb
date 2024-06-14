class RegionObservationLocation < ApplicationRecord
  belongs_to :region
  belongs_to :observation_location

  validates :region_id, uniqueness: { scope: :observation_location_id }
end
