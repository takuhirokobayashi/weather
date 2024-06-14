require "test_helper"
require 'webmock/minitest'

require_relative '../../app/models/jma_http_response_error'
require_relative '../../app/models/invalid_amedas_file_error'

class WeatherStationTest < ActiveSupport::TestCase
  fixtures :observation_locations

  def setup
    @observation_location = observation_locations( :negibozu )
  end

  test 'observation_locationが参照されていて正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはobservation_location_idを指定せずvalid?された'
  end

  test 'observation_locationが参照されていなくても正常' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはobservation_location_idを指定してvalid?された'
  end

  test 'station_numberが空だとエラー' do
    ws = WeatherStation.new(
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはstation_numberを指定せずvalid?された'
    assert_not_nil ws.errors[:station_number]
  end

  test 'station_numberが数字でないとエラー' do
    ws = WeatherStation.new(
      station_number: 'aaaaa',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはstation_numberに数字以外が指定されてvalid?された'
    assert_not_nil ws.errors[:station_number]
  end

  test '観測所の緯度及び経度情報が存在しない' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationは観測所の緯度及び経度情報が存在せずvalid?された'
  end

  test '観測所の緯度情報が存在しない' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      longitude_degrees: 20,
      longitude_minutes: 30.1,
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationは観測所の緯度情報が存在せずvalid?された'
    assert_not_nil ws.errors[:base]
  end

  test '観測所の経度情報が存在しない' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      latitude_degrees: 20,
      latitude_minutes: 30.1,
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationは観測所の経度情報が存在せずvalid?された'
    assert_not_nil ws.errors[:base]
  end

  test '観測所の緯度及び経度情報が存在する' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      latitude_degrees: 20,
      latitude_minutes: 30.1,
      longitude_degrees: 20,
      longitude_minutes: 30.1,
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationは観測所の緯度及び経度情報が存在してvalid?された'
  end

  test 'height_above_sea_levelが空でも正常' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはheight_above_sea_levelが指定せずvalid?された'
  end

  test 'height_above_sea_levelが数字でないとエラー' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_above_sea_level: 'aaaa',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはheight_above_sea_levelは数字以外が指定されてvalid?された'
    assert_not_nil ws.errors[:height_above_sea_level]
  end

  test 'height_above_sea_levelが整数でないとエラー' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_above_sea_level: '11.1',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはheight_above_sea_levelは整数以外が指定されてvalid?された'
    assert_not_nil ws.errors[:height_above_sea_level]
  end

  test 'height_above_sea_levelが整数で正常' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_above_sea_level: '11',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはheight_above_sea_levelは整数が指定されてvalid?された'
  end

  test 'height_of_anemometerが空でも正常' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはheight_of_anemometerが指定せずvalid?された'
  end

  test 'height_of_anemometerが数字でないとエラー' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_of_anemometer: 'aaaa',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはheight_of_anemometerが数字以外が指定されてvalid?された'
    assert_not_nil ws.errors[:height_of_anemometer]
  end

  test 'height_of_anemometerが数字で正常' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_of_anemometer: '11',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはheight_of_anemometerが数字が指定されてvalid?された'
  end

  test '観測所(雪)の緯度及び経度情報が存在しない' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationは観測所(雪)の緯度及び経度情報が存在せずvalid?された'
  end

  test '観測所(雪)の緯度情報が存在しない' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      longitude_degrees_snow: 20,
      longitude_minutes_snow: 30.1,
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationは観測所(雪)の緯度情報が存在せずvalid?された'
    assert_not_nil ws.errors[:base]
  end

  test '観測所(雪)の経度情報が存在しない' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      latitude_degrees_snow: 20,
      latitude_minutes_snow: 30.1,
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationは観測所の経度情報が存在せずvalid?された'
    assert_not_nil ws.errors[:base]
  end

  test '観測所(雪)の緯度及び経度情報が存在する' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      latitude_degrees_snow: 20,
      latitude_minutes_snow: 30.1,
      longitude_degrees_snow: 20,
      longitude_minutes_snow: 30.1,
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationは観測所(雪)の緯度及び経度情報が存在してvalid?された'
  end

  test 'height_above_sea_level_snowが空でも正常' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはheight_above_sea_level_snowが指定せずvalid?された'
  end

  test 'height_above_sea_level_snowが数字でないとエラー' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_above_sea_level_snow: 'aaaa',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはheight_above_sea_level_snowは数字以外が指定されてvalid?された'
    assert_not_nil ws.errors[:height_above_sea_level_snow]
  end

  test 'height_above_sea_level_snowが整数でないとエラー' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_above_sea_level_snow: '11.1',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはheight_above_sea_level_snowは整数以外が指定されてvalid?された'
    assert_not_nil ws.errors[:height_above_sea_level_snow]
  end

  test 'height_above_sea_level_snowが整数で正常' do
    ws = WeatherStation.new(
      observation_location_id: @observation_location.id,
      station_number: '11111',
      height_above_sea_level_snow: '11',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはheight_above_sea_level_snowは整数が指定されてvalid?された'
  end

  test 'sunshine_duration_measurement_summaryが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはsunshine_duration_measurement_summaryにnilを指定されてvalid?された'
    assert_not_nil ws.errors[:sunshine_duration_measurement_summary]
  end

  test 'sunshine_duration_measurement_summaryが0,1,2以外だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '3',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはsunshine_duration_measurement_summaryに3を指定されてvalid?された'
    assert_not_nil ws.errors[:sunshine_duration_measurement_summary]
  end

  test 'sunshine_duration_measurement_summaryが0だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_measurement_summaryに0を指定されてvalid?された'
  end

  test 'sunshine_duration_measurement_summaryが1だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '1',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_measurement_summaryに1を指定されてvalid?された'
  end

  test 'sunshine_duration_measurement_summaryが2だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '2',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_measurement_summaryに2を指定されてvalid?された'
  end

  test '開始日付が設定されていない' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはobservation_start_dateにnilを指定されてvalid?された'
    assert_not_nil ws.errors[:observation_start_date]
  end

  test '終了日付が設定されていない' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはobservation_end_dateにnilを指定されてvalid?された'
  end

  test '開始日付・終了日付が同日' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはobservation_start_dateとobservation_end_dateに同値を指定されてvalid?された'
  end

  test '開始日付が終了日付より前日' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-04-05' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはobservation_start_dateがobservation_end_dateより前日を指定されてvalid?された'
  end

  test '終了日付が開始日付より前日' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-03-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはobservation_end_dateがobservation_start_dateより前日を指定されてvalid?された'
    assert_not_nil ws.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがある状態で終了日付が設定されていないレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_end_date未設定のレコードがある状態で、WeatherStationはobservation_end_dateより後日を指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがある状態で開始日付に終了日付が重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2023-04-02' ),
      observation_end_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws_next.valid?, '同一station_numberでobservation_start_dateと同一のobservation_end_dateが指定されてvalid?された'
  end

  test '同一観測所にて終了日が存在しないレコードがある状態で開始日付をまたがるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2023-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_start_dateの日付がまたがる範囲で指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがある状態で開始日付に開始日付が重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2025-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_start_dateと同一のobservation_start_dateが指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがある状態で日付範囲の内側に重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-03' ),
      observation_end_date: Date.parse( '2025-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_end_dateがNULLのレコードに対してobservation_start_dateがobservation_start_dateより後日が指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがある状態で開始日以前のレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2023-04-03' ),
      observation_end_date: Date.parse( '2024-04-01' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws_next.valid?, '同一station_numberでobservation_end_dateがobservation_start_dateより前日が指定されてvalid?された'
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で開始日付に終了日付が重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2023-04-02' ),
      observation_end_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws_next.valid?, '同一station_numberでobservation_start_dateと同一のobservation_end_dateが指定されてvalid?された'
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で開始日付をまたがるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2023-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_start_dateの日付がまたがる範囲で指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で開始日付に開始日付が重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2025-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_start_dateと同一のobservation_start_dateが指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で終了日付に終了日付が重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-03' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_end_dateと同一のobservation_end_dateが指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で終了日付をまたがるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-03' ),
      observation_end_date: Date.parse( '2024-05-03' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberでobservation_end_dateの日付がまたがる範囲で指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で終了日付に開始日付が重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-05-02' ),
      observation_end_date: Date.parse( '2024-06-03' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws_next.valid?, '同一station_numberでobservation_end_dateと同一のobservation_start_dateが指定されてvalid?された'
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で日付範囲の内側に重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2025-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-03' ),
      observation_end_date: Date.parse( '2025-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberで登録されている日付範囲の内側に範囲が指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で日付範囲の外側に重なるレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2023-04-03' ),
      observation_end_date: Date.parse( '2025-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws_next.valid?, '同一station_numberで登録されている日付範囲の外側に範囲が指定されてvalid?された'
    assert_not_nil ws_next.errors[:base]
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で開始日以前のレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2023-04-03' ),
      observation_end_date: Date.parse( '2024-04-01' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws_next.valid?, '同一station_numberでobservation_end_dateがobservation_start_dateより前日が指定されてvalid?された'
  end

  test '同一観測所にて終了日が存在しないレコードがない状態で終了日以後のレコードを登録' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      observation_end_date: Date.parse( '2024-05-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    ws.save
    ws_next = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-05-03' ),
      observation_end_date: Date.parse( '2025-04-01' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws_next.valid?, '同一station_numberでobservation_start_dateがobservation_end_dateより後日が指定されてvalid?された'
  end

  test 'old_station_numberが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはold_station_numberを指定せずvalid?された'
    assert_not_nil ws.errors[:old_station_number]
  end

  test 'old_station_numberが数字で構成されていないとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: 'aaaaa',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはold_station_numberに数字以外が指定されてvalid?された'
    assert_not_nil ws.errors[:old_station_number]
  end

  test 'precipitation_statistics_linkが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはprecipitation_statistics_linkを指定せずvalid?された'
    assert_not_nil ws.errors[:precipitation_statistics_link]
  end

  test 'precipitation_statistics_linkが0だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはprecipitation_statistics_linkに0を指定されてvalid?された'
  end

  test 'precipitation_statistics_linkが1だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '1',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはprecipitation_statistics_linkに1を指定されてvalid?された'
  end

  test 'precipitation_statistics_linkが0,1以外だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '2',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはprecipitation_statistics_linkに2を指定されてvalid?された'
    assert_not_nil ws.errors[:precipitation_statistics_link]
  end

  test 'wind_statistics_linkが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはwind_statistics_linkを指定せずvalid?された'
    assert_not_nil ws.errors[:wind_statistics_link]
  end

  test 'wind_statistics_linkが0だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはwind_statistics_linkに0を指定されてvalid?された'
  end

  test 'wind_statistics_linkが1だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '1',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはwind_statistics_linkに1を指定されてvalid?された'
  end

  test 'wind_statistics_linkが4だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '4',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはwind_statistics_linkに4を指定されてvalid?された'
  end

  test 'wind_statistics_linkが5だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '5',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはwind_statistics_linkに5を指定されてvalid?された'
  end

  test 'wind_statistics_linkが0,1,4,5以外だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '2',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはwind_statistics_linkに2を指定されてvalid?された'
    assert_not_nil ws.errors[:wind_statistics_link]
  end

  test 'temperature_statistics_linkが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはtemperature_statistics_linkを指定せずvalid?された'
    assert_not_nil ws.errors[:temperature_statistics_link]
  end

  test 'temperature_statistics_linkが0だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはtemperature_statistics_linkに0を指定されてvalid?された'
  end

  test 'temperature_statistics_linkが1だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '1',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはtemperature_statistics_linkに1を指定されてvalid?された'
  end

  test 'temperature_statistics_linkが4だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '4',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはtemperature_statistics_linkに4を指定されてvalid?された'
  end

  test 'temperature_statistics_linkが5だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '5',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはtemperature_statistics_linkに5を指定されてvalid?された'
  end

  test 'temperature_statistics_linkが0,1,4,5以外だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '2',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはtemperature_statistics_linkに2を指定されてvalid?された'
    assert_not_nil ws.errors[:temperature_statistics_link]
  end

  test 'sunshine_duration_statistics_linkが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkを指定せずvalid?された'
    assert_not_nil ws.errors[:sunshine_duration_statistics_link]
  end

  test 'sunshine_duration_statistics_linkが0だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkに0を指定されてvalid?された'
  end

  test 'sunshine_duration_statistics_linkが1だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '1',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkに1を指定されてvalid?された'
  end

  test 'sunshine_duration_statistics_linkが4だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '4',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkに4を指定されてvalid?された'
  end

  test 'sunshine_duration_statistics_linkが5だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '5',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkに5を指定されてvalid?された'
  end

  test 'sunshine_duration_statistics_linkが6だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '6',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkに6を指定されてvalid?された'
  end

  test 'sunshine_duration_statistics_linkが7だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '7',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkに7を指定されてvalid?された'
  end

  test 'sunshine_duration_statistics_linkが0,1,4,5,6,7以外だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '2',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはsunshine_duration_statistics_linkに2を指定されてvalid?された'
    assert_not_nil ws.errors[:sunshine_duration_statistics_link]
  end

  test 'snow_depth_statistics_linkが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはsnow_depth_statistics_linkを指定せずvalid?された'
    assert_not_nil ws.errors[:snow_depth_statistics_link]
  end

  test 'snow_depth_statistics_linkが0だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsnow_depth_statistics_linkに0を指定されてvalid?された'
  end

  test 'snow_depth_statistics_linkが1だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '1',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはsnow_depth_statistics_linkに1を指定されてvalid?された'
  end

  test 'snow_depth_statistics_linkが0,1以外だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '2',
      humidity_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはsnow_depth_statistics_linkに2を指定されてvalid?された'
    assert_not_nil ws.errors[:snow_depth_statistics_link]
  end

  test 'humidity_statistics_linkが空だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0'
    )
    assert_not ws.valid?, 'WeatherStationはhumidity_statistics_linkを指定せずvalid?された'
    assert_not_nil ws.errors[:humidity_statistics_link]
  end

  test 'humidity_statistics_linkが0だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '0'
    )
    assert ws.valid?, 'WeatherStationはhumidity_statistics_linkに0を指定されてvalid?された'
  end

  test 'humidity_statistics_linkが1だと正常' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '1'
    )
    assert ws.valid?, 'WeatherStationはhumidity_statistics_linkに1を指定されてvalid?された'
  end

  test 'humidity_statistics_linkが0,1以外だとエラー' do
    ws = WeatherStation.new(
      station_number: '11111',
      sunshine_duration_measurement_summary: '0',
      observation_start_date: Date.parse( '2024-04-02' ),
      old_station_number: '11111',
      precipitation_statistics_link: '0',
      wind_statistics_link: '0',
      temperature_statistics_link: '0',
      sunshine_duration_statistics_link: '0',
      snow_depth_statistics_link: '0',
      humidity_statistics_link: '2'
    )
    assert_not ws.valid?, 'WeatherStationはhumidity_statistics_linkに2を指定されてvalid?された'
    assert_not_nil ws.errors[:humidity_statistics_link]
  end

  test 'HTTPエラーが発生した' do
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 500, body: '' )
    assert_raises( JmaHttpResponseError ) do
      WeatherStation.get_list()
    end
  end

  test 'AMEDASマスター、開始日と終了日の日付で開始日の日付の方が終了日に対して未来日' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_error_start_end.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    assert_raises( InvalidAmedasFileError ) do
      WeatherStation.get_list()
    end
  end

  test 'AMEDASマスター、レコード間で期間が重複している' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_error_overlapping_period.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    assert_raises( InvalidAmedasFileError ) do
      WeatherStation.get_list()
    end
  end

  test 'AMEDASマスター、サンプリングデータ(開始終了同日、前レコードの終了日開始日同日あり)' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_sampling.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      WeatherStation.get_list()
    end
  end

  test 'AMEDASマスター、現行のデータを取り込み' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_raw.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      WeatherStation.get_list()
    end
    assert_equal 7650, WeatherStation.all.count()
  end
end
