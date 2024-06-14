class CreateWeatherStations < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_stations do |t|
      t.references :observation_location, null: true, foreign_key: true
      t.string :station_number, null: false
      t.string :station_name
      t.string :station_name_kana
      t.string :station_name_romaji
      t.string :snow_gauge_station_name
      t.string :snow_gauge_station_name_kana
      t.string :snow_gauge_station_name_romaji
      t.integer :latitude_degrees
      t.decimal :latitude_minutes, precision: 3, scale: 1
      t.integer :longitude_degrees
      t.decimal :longitude_minutes, precision: 3, scale: 1
      t.integer :height_above_sea_level
      t.decimal :height_of_anemometer, precision: 4, scale: 1
      t.integer :latitude_degrees_snow
      t.decimal :latitude_minutes_snow, precision: 3, scale: 1
      t.integer :longitude_degrees_snow
      t.decimal :longitude_minutes_snow, precision: 3, scale: 1
      t.integer :height_above_sea_level_snow
      t.boolean :precipitation_measurement_summary, default: false, null: false
      t.boolean :wind_measurement_summary, default: false, null: false
      t.boolean :temperature_measurement_summary, default: false, null: false
      t.string :sunshine_duration_measurement_summary, null: false
      t.boolean :snow_depth_measurement_summary, default: false, null: false
      t.boolean :humidity_measurement_summary, default: false, null: false
      t.date :observation_start_date, null: false
      t.date :observation_end_date
      t.string :old_station_number, null: false
      t.string :precipitation_statistics_link, null: false
      t.string :wind_statistics_link, null: false
      t.string :temperature_statistics_link, null: false
      t.string :sunshine_duration_statistics_link, null: false
      t.string :snow_depth_statistics_link, null: false
      t.string :humidity_statistics_link, null: false

      t.timestamps
    end
  end
end
