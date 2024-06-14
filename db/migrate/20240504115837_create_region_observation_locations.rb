class CreateRegionObservationLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :region_observation_locations do |t|
      t.references :region, null: false, foreign_key: true
      t.references :observation_location, null: false, foreign_key: true

      t.timestamps
    end

    add_index :region_observation_locations, [:region_id, :observation_location_id], unique: true, name: 'index_unique_region_observation_location'
  end
end
