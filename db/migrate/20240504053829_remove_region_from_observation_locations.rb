class RemoveRegionFromObservationLocations < ActiveRecord::Migration[7.1]
  def change
    remove_reference :observation_locations, :region, null: false, foreign_key: true
  end
end
