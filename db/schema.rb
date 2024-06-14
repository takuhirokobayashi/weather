# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_26_113113) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_states", force: :cascade do |t|
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measurements", force: :cascade do |t|
    t.decimal "temperature", precision: 5, scale: 2
    t.integer "temperature_quality_information", null: false
    t.integer "temperature_homogeneity_number", null: false
    t.decimal "precipitation", precision: 7, scale: 2
    t.boolean "precipitation_no_phenomena_information", default: false, null: false
    t.integer "precipitation_quality_information", null: false
    t.integer "precipitation_homogeneity_number", null: false
    t.integer "snowfall"
    t.boolean "snowfall_no_phenomena_information", default: false, null: false
    t.integer "snowfall_quality_information", null: false
    t.integer "snowfall_homogeneity_number", null: false
    t.integer "snow_depth"
    t.boolean "snow_depth_no_phenomena_information", default: false, null: false
    t.integer "snow_depth_quality_information", null: false
    t.integer "snow_depth_homogeneity_number", null: false
    t.decimal "sunshine_duration", precision: 4, scale: 2
    t.boolean "sunshine_duration_no_phenomena_information", default: false, null: false
    t.integer "sunshine_duration_quality_information", null: false
    t.integer "sunshine_duration_homogeneity_number", null: false
    t.decimal "wind_speed", precision: 6, scale: 2
    t.integer "wind_speed_quality_information", null: false
    t.bigint "wind_direction_id", null: false
    t.integer "wind_direction_quality_information", null: false
    t.integer "wind_direction_homogeneity_number", null: false
    t.integer "solar_radiation"
    t.integer "solar_radiation_quality_information", null: false
    t.integer "solar_radiation_homogeneity_number", null: false
    t.decimal "local_atmospheric_pressure", precision: 7, scale: 2
    t.integer "local_atmospheric_pressure_quality_information", null: false
    t.integer "local_atmospheric_pressure_homogeneity_number", null: false
    t.decimal "sea_atmospheric_pressure", precision: 7, scale: 2
    t.integer "sea_atmospheric_pressure_quality_information", null: false
    t.integer "sea_atmospheric_pressure_homogeneity_number", null: false
    t.integer "relative_humidity"
    t.integer "relative_humidity_quality_information", null: false
    t.integer "relative_humidity_homogeneity_number", null: false
    t.decimal "vapor_pressure", precision: 6, scale: 2
    t.integer "vapor_pressure_quality_information", null: false
    t.integer "vapor_pressure_homogeneity_number", null: false
    t.decimal "dew_point_temperature", precision: 5, scale: 2
    t.integer "dew_point_temperature_quality_information", null: false
    t.integer "dew_point_temperature_homogeneity_number", null: false
    t.bigint "weather_symbol_id", null: false
    t.integer "weather_quality_information", null: false
    t.integer "weather_homogeneity_number", null: false
    t.integer "cloud_cover"
    t.integer "cloud_cover_quality_information", null: false
    t.integer "cloud_cover_homogeneity_number", null: false
    t.decimal "visibility", precision: 6, scale: 3
    t.integer "visibility_quality_information", null: false
    t.integer "visibility_homogeneity_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "weather_station_id", null: false
    t.datetime "observation_date_time"
    t.index ["weather_station_id"], name: "index_measurements_on_weather_station_id"
    t.index ["weather_symbol_id"], name: "index_measurements_on_weather_symbol_id"
    t.index ["wind_direction_id"], name: "index_measurements_on_wind_direction_id"
  end

  create_table "observation_locations", force: :cascade do |t|
    t.string "stid", null: false
    t.string "stname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "region_observation_locations", force: :cascade do |t|
    t.bigint "region_id", null: false
    t.bigint "observation_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["observation_location_id"], name: "index_region_observation_locations_on_observation_location_id"
    t.index ["region_id", "observation_location_id"], name: "index_unique_region_observation_location", unique: true
    t.index ["region_id"], name: "index_region_observation_locations_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "prid", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weather_requests", force: :cascade do |t|
    t.bigint "observation_location_id", null: false
    t.datetime "observation_date_time", null: false
    t.string "status", null: false
    t.datetime "request_time", null: false
    t.datetime "success_time"
    t.integer "retry_count", default: 0
    t.text "error_message"
    t.bigint "measurement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measurement_id"], name: "index_weather_requests_on_measurement_id"
    t.index ["observation_location_id"], name: "index_weather_requests_on_observation_location_id"
  end

  create_table "weather_stations", force: :cascade do |t|
    t.bigint "observation_location_id"
    t.string "station_number", null: false
    t.string "station_name"
    t.string "station_name_kana"
    t.string "station_name_romaji"
    t.string "snow_gauge_station_name"
    t.string "snow_gauge_station_name_kana"
    t.string "snow_gauge_station_name_romaji"
    t.integer "latitude_degrees"
    t.decimal "latitude_minutes", precision: 3, scale: 1
    t.integer "longitude_degrees"
    t.decimal "longitude_minutes", precision: 3, scale: 1
    t.integer "height_above_sea_level"
    t.decimal "height_of_anemometer", precision: 4, scale: 1
    t.integer "latitude_degrees_snow"
    t.decimal "latitude_minutes_snow", precision: 3, scale: 1
    t.integer "longitude_degrees_snow"
    t.decimal "longitude_minutes_snow", precision: 3, scale: 1
    t.integer "height_above_sea_level_snow"
    t.boolean "precipitation_measurement_summary", default: false, null: false
    t.boolean "wind_measurement_summary", default: false, null: false
    t.boolean "temperature_measurement_summary", default: false, null: false
    t.string "sunshine_duration_measurement_summary", null: false
    t.boolean "snow_depth_measurement_summary", default: false, null: false
    t.boolean "humidity_measurement_summary", default: false, null: false
    t.date "observation_start_date", null: false
    t.date "observation_end_date"
    t.string "old_station_number", null: false
    t.string "precipitation_statistics_link", null: false
    t.string "wind_statistics_link", null: false
    t.string "temperature_statistics_link", null: false
    t.string "sunshine_duration_statistics_link", null: false
    t.string "snow_depth_statistics_link", null: false
    t.string "humidity_statistics_link", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["observation_location_id"], name: "index_weather_stations_on_observation_location_id"
  end

  create_table "weather_symbols", force: :cascade do |t|
    t.integer "weather_code", null: false
    t.string "weather_symbol", null: false
    t.string "weather", null: false
    t.boolean "visual_observation", default: false, null: false
    t.boolean "instrumental_observation", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wind_directions", force: :cascade do |t|
    t.string "compass_direction", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "measurements", "weather_stations"
  add_foreign_key "measurements", "weather_symbols"
  add_foreign_key "measurements", "wind_directions"
  add_foreign_key "region_observation_locations", "observation_locations"
  add_foreign_key "region_observation_locations", "regions"
  add_foreign_key "weather_requests", "measurements"
  add_foreign_key "weather_requests", "observation_locations"
  add_foreign_key "weather_stations", "observation_locations"
end
