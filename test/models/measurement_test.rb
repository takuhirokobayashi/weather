require "test_helper"
require 'webmock/minitest'

require_relative '../../app/models/invalid_measurement_csv_file_error'
require_relative '../../app/models/jma_http_response_error'
require_relative '../../app/models/jma_too_many_requests'

class MeasurementTest < ActiveSupport::TestCase
  fixtures :wind_directions, :weather_symbols, :measurements, :observation_locations, :weather_stations, :weather_requests

  def setup
    @wind_direction = wind_directions( :totonan )
    @weather_symbol = weather_symbols( :sinoame )
    @weather_station = weather_stations( :fujissaan )
    @heaven = observation_locations( :tengoku )
    @observation_location = observation_locations( :negibozu )
    @tinoike = weather_stations( :tinoike )
    @hell = observation_locations( :jigoku )
  end

  test 'weather_stationが参照されていないとエラー' do
    m = Measurement.new(
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはweather_station_idを指定せずvalid?された'
    assert_not_nil m.errors[:weather_station]
  end

  test 'weather_stationが参照されていて正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_station_idを指定されてvalid?された'
  end

  test 'observation_date_timeが空だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはobservation_date_timeを指定せずvalid?された'
    assert_not_nil m.errors[:observation_date_time]
  end

  test 'observation_date_timeが存在していて正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはobservation_date_timeを指定されてvalid?された'
  end

  test 'temperatureが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperatureを指定せずvalid?された'
  end

  test 'temperatureが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature: 'a',
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはtemperatureに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:temperature]
  end

  test 'temperatureが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature: '1.1',
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperatureに数字が指定されてvalid?された'
  end

  test 'temperature_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperature_quality_informationに0が指定されてvalid?された'
  end

  test 'temperature_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '1',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperature_quality_informationに1が指定されてvalid?された'
  end

  test 'temperature_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '2',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperature_quality_informationに2が指定されてvalid?された'
  end

  test 'temperature_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '4',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperature_quality_informationに4が指定されてvalid?された'
  end

  test 'temperature_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '5',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperature_quality_informationに5が指定されてvalid?された'
  end

  test 'temperature_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '8',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperature_quality_informationに8が指定されてvalid?された'
  end

  test 'temperature_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '3',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはtemperature_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:temperature_quality_information]
  end

  test 'temperature_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: 'a',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはtemperature_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:temperature_homogeneity_number]
  end

  test 'temperature_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはtemperature_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'precipitationが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitationを指定せずvalid?された'
  end

  test 'precipitationが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation: 'a',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはprecipitationに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:precipitation]
  end

  test 'precipitationが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation: '1.1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitationに数字が指定されてvalid?された'
  end

  test 'precipitation_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitation_quality_informationに0が指定されてvalid?された'
  end

  test 'precipitation_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '1',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitation_quality_informationに1が指定されてvalid?された'
  end

  test 'precipitation_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '2',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitation_quality_informationに2が指定されてvalid?された'
  end

  test 'precipitation_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '4',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitation_quality_informationに4が指定されてvalid?された'
  end

  test 'precipitation_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '5',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitation_quality_informationに5が指定されてvalid?された'
  end

  test 'precipitation_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '8',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitation_quality_informationに8が指定されてvalid?された'
  end

  test 'precipitation_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '3',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはprecipitation_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:precipitation_quality_information]
  end

  test 'precipitation_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: 'a',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはprecipitation_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:precipitation_homogeneity_number]
  end
  
  test 'precipitation_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはprecipitation_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'snowfallが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfallを指定せずvalid?された'
  end

  test 'snowfallが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall: 'a',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnowfallに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:snowfall]
  end

  test 'snowfallが小数でエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall: '1.1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnowfallに小数が指定されてvalid?された'
    assert_not_nil m.errors[:snowfall]
  end

  test 'snowfallが整数で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfallに整数が指定されてvalid?された'
  end

  test 'snowfall_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfall_quality_informationに0が指定されてvalid?された'
  end

  test 'snowfall_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '1',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfall_quality_informationに1が指定されてvalid?された'
  end

  test 'snowfall_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '2',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfall_quality_informationに2が指定されてvalid?された'
  end

  test 'snowfall_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '4',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfall_quality_informationに4が指定されてvalid?された'
  end

  test 'snowfall_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '5',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfall_quality_informationに5が指定されてvalid?された'
  end

  test 'snowfall_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '8',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfall_quality_informationに8が指定されてvalid?された'
  end

  test 'snowfall_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '3',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnowfall_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:snowfall_quality_information]
  end

  test 'snowfall_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: 'a',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnowfall_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:snowfall_homogeneity_number]
  end
  
  test 'snowfall_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnowfall_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'snow_depthが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depthを指定せずvalid?された'
  end

  test 'snow_depthが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth: 'a',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnow_depthに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:snow_depth]
  end

  test 'snow_depthが小数でエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth: '1.1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnow_depthに小数が指定されてvalid?された'
    assert_not_nil m.errors[:snow_depth]
  end

  test 'snow_depthが整数で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depthに整数が指定されてvalid?された'
  end

  test 'snow_depth_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depth_quality_informationに0が指定されてvalid?された'
  end

  test 'snow_depth_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '1',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depth_quality_informationに1が指定されてvalid?された'
  end

  test 'snow_depth_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '2',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depth_quality_informationに2が指定されてvalid?された'
  end

  test 'snow_depth_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '4',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depth_quality_informationに4が指定されてvalid?された'
  end

  test 'snow_depth_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '5',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depth_quality_informationに5が指定されてvalid?された'
  end

  test 'snow_depth_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '8',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depth_quality_informationに8が指定されてvalid?された'
  end

  test 'snow_depth_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '3',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnow_depth_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:snow_depth_quality_information]
  end

  test 'snow_depth_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: 'a',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsnow_depth_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:snow_depth_homogeneity_number]
  end
  
  test 'snow_depth_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsnow_depth_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'sunshine_durationが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_durationを指定せずvalid?された'
  end

  test 'sunshine_durationが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration: 'a',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsunshine_durationに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:sunshine_duration]
  end

  test 'sunshine_durationが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration: '1.1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_durationに数字が指定されてvalid?された'
  end

  test 'sunshine_duration_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_duration_quality_informationに0が指定されてvalid?された'
  end

  test 'sunshine_duration_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '1',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_duration_quality_informationに1が指定されてvalid?された'
  end

  test 'sunshine_duration_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '2',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_duration_quality_informationに2が指定されてvalid?された'
  end

  test 'sunshine_duration_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '4',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_duration_quality_informationに4が指定されてvalid?された'
  end

  test 'sunshine_duration_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '5',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_duration_quality_informationに5が指定されてvalid?された'
  end

  test 'sunshine_duration_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '8',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_duration_quality_informationに8が指定されてvalid?された'
  end

  test 'sunshine_duration_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '3',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsunshine_duration_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:sunshine_duration_quality_information]
  end

  test 'sunshine_duration_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: 'a',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsunshine_duration_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:sunshine_duration_homogeneity_number]
  end
  
  test 'sunshine_duration_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsunshine_duration_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'wind_speedが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speedを指定せずvalid?された'
  end

  test 'wind_speedが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed: 'a',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはwind_speedに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:wind_speed]
  end

  test 'wind_speedが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed: '1.1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speedに数字が指定されてvalid?された'
  end

  test 'wind_speed_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speed_quality_informationに0が指定されてvalid?された'
  end

  test 'wind_speed_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '1',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speed_quality_informationに1が指定されてvalid?された'
  end

  test 'wind_speed_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '2',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speed_quality_informationに2が指定されてvalid?された'
  end

  test 'wind_speed_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '4',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speed_quality_informationに4が指定されてvalid?された'
  end

  test 'wind_speed_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '5',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speed_quality_informationに5が指定されてvalid?された'
  end

  test 'wind_speed_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '8',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_speed_quality_informationに8が指定されてvalid?された'
  end

  test 'wind_speed_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '3',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはwind_speed_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:wind_speed_quality_information]
  end

  test 'wind_directionが参照されていないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはwind_directionを指定せずvalid?された'
    assert_not_nil m.errors[:wind_direction]
  end

  test 'wind_directionが参照されていて正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_directionを指定してvalid?された'
  end

  test 'wind_direction_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_direction_quality_informationに0が指定されてvalid?された'
  end

  test 'wind_direction_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '1',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_direction_quality_informationに1が指定されてvalid?された'
  end

  test 'wind_direction_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '2',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_direction_quality_informationに2が指定されてvalid?された'
  end

  test 'wind_direction_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '4',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_direction_quality_informationに4が指定されてvalid?された'
  end

  test 'wind_direction_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '5',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_direction_quality_informationに5が指定されてvalid?された'
  end

  test 'wind_direction_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '8',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_direction_quality_informationに8が指定されてvalid?された'
  end

  test 'wind_direction_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '3',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはwind_direction_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:wind_direction_quality_information]
  end

  test 'wind_direction_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: 'a',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはwind_direction_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:wind_direction_homogeneity_number]
  end
  
  test 'wind_direction_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはwind_direction_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'solar_radiationが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiationを指定せずvalid?された'
  end

  test 'solar_radiationが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation: 'a',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsolar_radiationに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:solar_radiation]
  end

  test 'solar_radiationが小数でエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation: '1.1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsolar_radiationに小数が指定されてvalid?された'
    assert_not_nil m.errors[:solar_radiation]
  end

  test 'solar_radiationが整数で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiationに整数が指定されてvalid?された'
  end

  test 'solar_radiation_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiation_quality_informationに0が指定されてvalid?された'
  end

  test 'solar_radiation_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '1',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiation_quality_informationに1が指定されてvalid?された'
  end

  test 'solar_radiation_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '2',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiation_quality_informationに2が指定されてvalid?された'
  end

  test 'solar_radiation_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '4',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiation_quality_informationに4が指定されてvalid?された'
  end

  test 'solar_radiation_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '5',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiation_quality_informationに5が指定されてvalid?された'
  end

  test 'solar_radiation_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '8',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiation_quality_informationに8が指定されてvalid?された'
  end

  test 'solar_radiation_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '3',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsolar_radiation_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:solar_radiation_quality_information]
  end

  test 'solar_radiation_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: 'a',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsolar_radiation_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:solar_radiation_homogeneity_number]
  end
  
  test 'solar_radiation_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsolar_radiation_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'local_atmospheric_pressureが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressureを指定せずvalid?された'
  end

  test 'local_atmospheric_pressureが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure: 'a',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはlocal_atmospheric_pressureに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:local_atmospheric_pressure]
  end

  test 'local_atmospheric_pressureが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure: '1.1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressureに数字が指定されてvalid?された'
  end

  test 'local_atmospheric_pressure_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressure_quality_informationに0が指定されてvalid?された'
  end

  test 'local_atmospheric_pressure_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '1',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressure_quality_informationに1が指定されてvalid?された'
  end

  test 'local_atmospheric_pressure_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '2',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressure_quality_informationに2が指定されてvalid?された'
  end

  test 'local_atmospheric_pressure_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '4',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressure_quality_informationに4が指定されてvalid?された'
  end

  test 'local_atmospheric_pressure_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '5',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressure_quality_informationに5が指定されてvalid?された'
  end

  test 'local_atmospheric_pressure_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '8',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressure_quality_informationに8が指定されてvalid?された'
  end

  test 'local_atmospheric_pressure_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '3',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはlocal_atmospheric_pressure_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:local_atmospheric_pressure_quality_information]
  end

  test 'local_atmospheric_pressure_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: 'a',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはlocal_atmospheric_pressure_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:local_atmospheric_pressure_homogeneity_number]
  end
  
  test 'local_atmospheric_pressure_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはlocal_atmospheric_pressure_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressureが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressureを指定せずvalid?された'
  end

  test 'sea_atmospheric_pressureが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure: 'a',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsea_atmospheric_pressureに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:sea_atmospheric_pressure]
  end

  test 'sea_atmospheric_pressureが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure: '1.1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressureに数字が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressure_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressure_quality_informationに0が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressure_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '1',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressure_quality_informationに1が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressure_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '2',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressure_quality_informationに2が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressure_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '4',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressure_quality_informationに4が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressure_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '5',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressure_quality_informationに5が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressure_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '8',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressure_quality_informationに8が指定されてvalid?された'
  end

  test 'sea_atmospheric_pressure_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '3',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsea_atmospheric_pressure_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:sea_atmospheric_pressure_quality_information]
  end

  test 'sea_atmospheric_pressure_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: 'a',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはsea_atmospheric_pressure_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:sea_atmospheric_pressure_homogeneity_number]
  end
  
  test 'sea_atmospheric_pressure_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはsea_atmospheric_pressure_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'relative_humidityが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidityを指定せずvalid?された'
  end

  test 'relative_humidityが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity: 'a',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはrelative_humidityに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:relative_humidity]
  end

  test 'relative_humidityが小数でエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity: '1.1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはrelative_humidityに小数が指定されてvalid?された'
    assert_not_nil m.errors[:relative_humidity]
  end

  test 'relative_humidityが整数で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidityに整数が指定されてvalid?された'
  end

  test 'relative_humidity_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidity_quality_informationに0が指定されてvalid?された'
  end

  test 'relative_humidity_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '1',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidity_quality_informationに1が指定されてvalid?された'
  end

  test 'relative_humidity_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '2',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidity_quality_informationに2が指定されてvalid?された'
  end

  test 'relative_humidity_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '4',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidity_quality_informationに4が指定されてvalid?された'
  end

  test 'relative_humidity_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '5',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidity_quality_informationに5が指定されてvalid?された'
  end

  test 'relative_humidity_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '8',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidity_quality_informationに8が指定されてvalid?された'
  end

  test 'relative_humidity_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '3',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはrelative_humidity_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:relative_humidity_quality_information]
  end

  test 'relative_humidity_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: 'a',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはrelative_humidity_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:relative_humidity_homogeneity_number]
  end
  
  test 'relative_humidity_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはrelative_humidity_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'vapor_pressureが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressureを指定せずvalid?された'
  end

  test 'vapor_pressureが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure: 'a',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはvapor_pressureに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:vapor_pressure]
  end

  test 'vapor_pressureが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure: '1.1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressureに数字が指定されてvalid?された'
  end

  test 'vapor_pressure_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressure_quality_informationに0が指定されてvalid?された'
  end

  test 'vapor_pressure_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '1',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressure_quality_informationに1が指定されてvalid?された'
  end

  test 'vapor_pressure_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '2',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressure_quality_informationに2が指定されてvalid?された'
  end

  test 'vapor_pressure_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '4',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressure_quality_informationに4が指定されてvalid?された'
  end

  test 'vapor_pressure_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '5',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressure_quality_informationに5が指定されてvalid?された'
  end

  test 'vapor_pressure_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '8',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressure_quality_informationに8が指定されてvalid?された'
  end

  test 'vapor_pressure_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '3',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはvapor_pressure_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:vapor_pressure_quality_information]
  end

  test 'vapor_pressure_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: 'a',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはvapor_pressure_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:vapor_pressure_homogeneity_number]
  end
  
  test 'vapor_pressure_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvapor_pressure_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'dew_point_temperatureが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperatureを指定せずvalid?された'
  end

  test 'dew_point_temperatureが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature: 'a',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはdew_point_temperatureに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:dew_point_temperature]
  end

  test 'dew_point_temperatureが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature: '1.1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperatureに数字が指定されてvalid?された'
  end

  test 'dew_point_temperature_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperature_quality_informationに0が指定されてvalid?された'
  end

  test 'dew_point_temperature_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '1',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperature_quality_informationに1が指定されてvalid?された'
  end

  test 'dew_point_temperature_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '2',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperature_quality_informationに2が指定されてvalid?された'
  end

  test 'dew_point_temperature_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '4',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperature_quality_informationに4が指定されてvalid?された'
  end

  test 'dew_point_temperature_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '5',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperature_quality_informationに5が指定されてvalid?された'
  end

  test 'dew_point_temperature_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '8',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperature_quality_informationに8が指定されてvalid?された'
  end

  test 'dew_point_temperature_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '3',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはdew_point_temperature_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:dew_point_temperature_quality_information]
  end

  test 'dew_point_temperature_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: 'a',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはdew_point_temperature_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:dew_point_temperature_homogeneity_number]
  end
  
  test 'dew_point_temperature_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはdew_point_temperature_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'weather_symbolが参照されていないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはweather_symbolを指定せずvalid?された'
    assert_not_nil m.errors[:weather_symbol]
  end

  test 'weather_symbolが参照されていて正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_symbolを指定してvalid?された'
  end

  test 'weather_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_quality_informationに0が指定されてvalid?された'
  end

  test 'weather_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '1',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_quality_informationに1が指定されてvalid?された'
  end

  test 'weather_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '2',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_quality_informationに2が指定されてvalid?された'
  end

  test 'weather_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '4',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_quality_informationに4が指定されてvalid?された'
  end

  test 'weather_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '5',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_quality_informationに5が指定されてvalid?された'
  end

  test 'weather_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '8',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_quality_informationに8が指定されてvalid?された'
  end

  test 'weather_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '3',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはweather_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:weather_quality_information]
  end

  test 'weather_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: 'a',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはweather_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:weather_homogeneity_number]
  end
  
  test 'weather_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはweather_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'cloud_coverが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_coverを指定せずvalid?された'
  end

  test 'cloud_coverが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover: 'a',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはcloud_coverに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:cloud_cover]
  end

  test 'cloud_coverが小数でエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover: '1.1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはcloud_coverに小数が指定されてvalid?された'
    assert_not_nil m.errors[:cloud_cover]
  end

  test 'cloud_coverが-1だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover: '-1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはcloud_coverに-1が指定されてvalid?された'
    assert_not_nil m.errors[:cloud_cover]
  end

  test 'cloud_coverが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover: '0',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_coverに0が指定されてvalid?された'
  end

  test 'cloud_coverが10だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover: '10',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_coverに10が指定されてvalid?された'
  end

  test 'cloud_coverが11だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover: '11',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはcloud_coverに11が指定されてvalid?された'
    assert_not_nil m.errors[:cloud_cover]
  end

  test 'cloud_cover_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_cover_quality_informationに0が指定されてvalid?された'
  end

  test 'cloud_cover_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '1',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_cover_quality_informationに1が指定されてvalid?された'
  end

  test 'cloud_cover_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '2',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_cover_quality_informationに2が指定されてvalid?された'
  end

  test 'cloud_cover_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '4',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_cover_quality_informationに4が指定されてvalid?された'
  end

  test 'cloud_cover_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '5',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_cover_quality_informationに5が指定されてvalid?された'
  end

  test 'cloud_cover_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '8',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_cover_quality_informationに8が指定されてvalid?された'
  end

  test 'cloud_cover_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '3',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはcloud_cover_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:cloud_cover_quality_information]
  end

  test 'cloud_cover_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: 'a',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはcloud_cover_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:cloud_cover_homogeneity_number]
  end
  
  test 'cloud_cover_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはcloud_cover_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'visibilityが空でも正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibilityを指定せずvalid?された'
  end

  test 'visibilityが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility: 'a',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはvisibilityに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:visibility]
  end

  test 'visibilityが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility: '1.1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibilityに数字が指定されてvalid?された'
  end

  test 'visibility_quality_informationが0だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibility_quality_informationに0が指定されてvalid?された'
  end

  test 'visibility_quality_informationが1だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '1',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibility_quality_informationに1が指定されてvalid?された'
  end

  test 'visibility_quality_informationが2だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '2',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibility_quality_informationに2が指定されてvalid?された'
  end

  test 'visibility_quality_informationが4だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '4',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibility_quality_informationに4が指定されてvalid?された'
  end

  test 'visibility_quality_informationが5だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '5',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibility_quality_informationに5が指定されてvalid?された'
  end

  test 'visibility_quality_informationが8だと正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '8',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibility_quality_informationに8が指定されてvalid?された'
  end

  test 'visibility_quality_informationが0,1,2,4,5,8以外だとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '3',
      visibility_homogeneity_number: '1'
    )
    assert_not m.valid?, 'Measurementはvisibility_quality_informationに3が指定されてvalid?された'
    assert_not_nil m.errors[:visibility_quality_information]
  end

  test 'visibility_homogeneity_numberが数字でないとエラー' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: 'a'
    )
    assert_not m.valid?, 'Measurementはvisibility_homogeneity_numberに数字以外が指定されてvalid?された'
    assert_not_nil m.errors[:visibility_homogeneity_number]
  end
  
  test 'visibility_homogeneity_numberが数字で正常' do
    m = Measurement.new(
      weather_station_id: @weather_station.id,
      observation_date_time: Time.zone.parse( '2024-05-12 01:00:00' ),
      temperature_quality_information: '0',
      temperature_homogeneity_number: '1',
      precipitation_quality_information: '0',
      precipitation_homogeneity_number: '1',
      snowfall_quality_information: '0',
      snowfall_homogeneity_number: '1',
      snow_depth_quality_information: '0',
      snow_depth_homogeneity_number: '1',
      sunshine_duration_quality_information: '0',
      sunshine_duration_homogeneity_number: '1',
      wind_speed_quality_information: '0',
      wind_direction: @wind_direction,
      wind_direction_quality_information: '0',
      wind_direction_homogeneity_number: '1',
      solar_radiation_quality_information: '0',
      solar_radiation_homogeneity_number: '1',
      local_atmospheric_pressure_quality_information: '0',
      local_atmospheric_pressure_homogeneity_number: '1',
      sea_atmospheric_pressure_quality_information: '0',
      sea_atmospheric_pressure_homogeneity_number: '1',
      relative_humidity_quality_information: '0',
      relative_humidity_homogeneity_number: '1',
      vapor_pressure_quality_information: '0',
      vapor_pressure_homogeneity_number: '1',
      dew_point_temperature_quality_information: '0',
      dew_point_temperature_homogeneity_number: '1',
      weather_symbol: @weather_symbol,
      weather_quality_information: '0',
      weather_homogeneity_number: '1',
      cloud_cover_quality_information: '0',
      cloud_cover_homogeneity_number: '1',
      visibility_quality_information: '0',
      visibility_homogeneity_number: '1'
    )
    assert m.valid?, 'Measurementはvisibility_homogeneity_numberに数字が指定されてvalid?された'
  end

  test 'ダウンロードサイトトップにアクセス出来ない' do
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 500, body: '' )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( JmaHttpResponseError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal I18n.t(
      'errors.messages.get_weather_station_error', response_code: 500
    ), exception.message
  end

  test 'ダウンロードサイトトップよりPHP_SESSIONを取得できない' do
    response_html = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top_no_session.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: response_html )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( JmaHttpResponseError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal I18n.t( 'errors.messages.php_session_not_found' ), exception.message
  end

  test 'ダウンロードページにアクセス出来ない' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 500, body: '' )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( JmaHttpResponseError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal I18n.t( 'errors.messages.get_weather_station_error', response_code: 500 ), exception.message
  end

  test 'ダウンロードページがアクセス過多を表示する' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'too_many_request.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/html' }, body: response )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    assert_raises( JmaTooManyRequests ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
  end

  test 'ダウンロードCSVが想定した行数ではない' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response_csv = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'yokohama_no_row.csv' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/x-comma-separated-values' }, body: response_csv )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( InvalidMeasurementCsvFileError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal I18n.t(
      'errors.messages.insufficient_rows',
      weather_station_id: @tinoike.id,
      start_date: start_date, end_date: end_date
    ), exception.message
  end

  test 'ダウンロードCSVが想定した列数ではない' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response_csv = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'yokohama_51.csv' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/x-comma-separated-values' }, body: response_csv )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( InvalidMeasurementCsvFileError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal I18n.t(
      'errors.messages.insufficient_columns',
      weather_station_id: @tinoike.id,
      start_date: start_date, end_date: end_date
    ), exception.message
  end

  test '観測時間が正しく表記されていない' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response_csv = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'yokohama_wrong_time.csv' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/x-comma-separated-values' }, body: response_csv )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( InvalidMeasurementCsvFileError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal I18n.t(
      'errors.messages.datetime_issue',
      weather_station_id: @tinoike.id, start_date: start_date, end_date: end_date
    ), exception.message
  end

  test '観測時間が想定された時間ではない' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response_csv = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'yokohama_diff_time.csv' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/x-comma-separated-values' }, body: response_csv )
    start_date = Date.parse( '2023-01-03' )
    end_date = Date.parse( '2023-01-03' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( InvalidMeasurementCsvFileError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal I18n.t(
      'errors.messages.datetime_issue',
      weather_station_id: @tinoike.id, start_date: start_date, end_date: end_date
    ), exception.message
  end

  test '観測データが想定したデータではない' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response_csv = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'yokohama_wrong_data.csv' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/x-comma-separated-values' }, body: response_csv )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    exception = assert_raises( InvalidMeasurementCsvFileError ) do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    m_err = Measurement.new
    m_err.errors.add( :temperature_quality_information, :inclusion )
    assert_equal I18n.t(
      'errors.messages.validation_error',
      weather_station_id: @tinoike.id, observation_date_time: Time.zone.parse( '2023-01-01 01:00:00' ),
      detail: m_err.errors.full_messages[0]
    ), exception.message
  end

  test '観測データを追加' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response_csv = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'yokohama_raw.csv' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/x-comma-separated-values' }, body: response_csv )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    assert_nothing_raised do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal 24, WeatherRequest.where( observation_location: @hell ).where( where_str ).where( wr_arel_t[:measurement_id].not_eq( nil ) ).count
  end

  test '観測データを更新' do
    php_session = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'download_top.html' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_TOP )
    .to_return( status: 200, body: php_session )
    response_csv = File.read( Rails.root.join( 'test', 'response_data', 'measurement', 'yokohama_raw.csv' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_DOWNLOAD_MESUREMENT )
    .to_return( status: 200, headers: { content_type: 'text/x-comma-separated-values' }, body: response_csv )
    start_date = Date.parse( '2023-01-01' )
    end_date = Date.parse( '2023-01-01' )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day
    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    weather_requests = WeatherRequest.where( observation_location: @hell ).where( where_str )
    assert_nothing_raised do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_nothing_raised do
      Measurement.store_data( @hell, @tinoike.id, weather_requests, start_date, end_date )
    end
    assert_equal 24, WeatherRequest.where( observation_location: @hell ).where( where_str ).where( wr_arel_t[:measurement_id].not_eq( nil ) ).count
  end
end
