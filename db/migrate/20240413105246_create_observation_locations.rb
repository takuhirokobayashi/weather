class CreateObservationLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :observation_locations do |t|
      t.references :region, null: false, foreign_key: true
      t.string :stid, null: false
      t.string :stname, null: false

      t.timestamps
    end
  end
end
