class CreateMeasurements < ActiveRecord::Migration[7.1]
  def change
    create_table :measurements do |t|
      t.references :weather_station, null: false, foreign_key: true
      t.datetime :observation_date_time, null: false
      t.decimal :temperature, precision: 5, scale: 2
      t.integer :temperature_quality_information, null: false
      t.integer :temperature_homogeneity_number, null: false
      t.decimal :precipitation, precision: 7, scale: 2
      t.boolean :precipitation_no_phenomena_information, default: false, null: false
      t.integer :precipitation_quality_information, null: false
      t.integer :precipitation_homogeneity_number, null: false
      t.integer :snowfall
      t.boolean :snowfall_no_phenomena_information, default: false, null: false
      t.integer :snowfall_quality_information, null: false
      t.integer :snowfall_homogeneity_number, null: false
      t.integer :snow_depth
      t.boolean :snow_depth_no_phenomena_information, default: false, null: false
      t.integer :snow_depth_quality_information, null: false
      t.integer :snow_depth_homogeneity_number, null: false
      t.decimal :sunshine_duration, precision: 4, scale: 2
      t.boolean :sunshine_duration_no_phenomena_information, default: false, null: false
      t.integer :sunshine_duration_quality_information, null: false
      t.integer :sunshine_duration_homogeneity_number, null: false
      t.decimal :wind_speed, precision: 6, scale: 2
      t.integer :wind_speed_quality_information, null: false
      t.references :wind_direction, null: false, foreign_key: true
      t.integer :wind_direction_quality_information, null: false
      t.integer :wind_direction_homogeneity_number, null: false
      t.integer :solar_radiation
      t.integer :solar_radiation_quality_information, null: false
      t.integer :solar_radiation_homogeneity_number, null: false
      t.decimal :local_atmospheric_pressure, precision: 7, scale: 2
      t.integer :local_atmospheric_pressure_quality_information, null: false
      t.integer :local_atmospheric_pressure_homogeneity_number, null: false
      t.decimal :sea_atmospheric_pressure, precision: 7, scale: 2
      t.integer :sea_atmospheric_pressure_quality_information, null: false
      t.integer :sea_atmospheric_pressure_homogeneity_number, null: false
      t.integer :relative_humidity
      t.integer :relative_humidity_quality_information, null: false
      t.integer :relative_humidity_homogeneity_number, null: false
      t.decimal :vapor_pressure, precision: 6, scale: 2
      t.integer :vapor_pressure_quality_information, null: false
      t.integer :vapor_pressure_homogeneity_number, null: false
      t.decimal :dew_point_temperature, precision: 5, scale: 2
      t.integer :dew_point_temperature_quality_information, null: false
      t.integer :dew_point_temperature_homogeneity_number, null: false
      t.references :weather_symbol, null: false, foreign_key: true
      t.integer :weather_quality_information, null: false
      t.integer :weather_homogeneity_number, null: false
      t.integer :cloud_cover
      t.integer :cloud_cover_quality_information, null: false
      t.integer :cloud_cover_homogeneity_number, null: false
      t.decimal :visibility, precision: 6, scale: 3
      t.integer :visibility_quality_information, null: false
      t.integer :visibility_homogeneity_number, null: false

      t.timestamps
    end
  end
end
