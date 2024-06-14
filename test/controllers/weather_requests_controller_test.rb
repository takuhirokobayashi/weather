require "test_helper"
require 'sidekiq/testing'

class WeatherRequestsControllerTest < ActionDispatch::IntegrationTest
  fixtures :wind_directions, :weather_symbols, :weather_stations, :measurements, :regions, :observation_locations, :region_observation_locations, :weather_requests

  setup do
    @observation_location = observation_locations( :negibozu )
    @ol_tengoku = observation_locations( :tengoku )
    @measurement_tengoku_one = measurements( :tengoku_one )
  end

  test "観測地点一覧取得_パラメタなし" do
    get weather_requests_url, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得_start_dateなし" do
    get weather_requests_url, params: { end_date: '2022-01-01', observation_location_id: @observation_location.id }, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得_end_dateなし" do
    get weather_requests_url, params: { start_date: '2022-01-01', observation_location_id: @observation_location.id }, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得_observation_location_idなし" do
    get weather_requests_url, params: { start_date: '2022-01-01', end_date: '2022-01-01' }, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得_start_dateパラメタ不正" do
    get weather_requests_url, params: { start_date: 'aaaaa', end_date: '2022-01-01', observation_location_id: @observation_location.id }, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得_end_dateパラメタ不正" do
    get weather_requests_url, params: { start_date: '2022-01-01', end_date: 'bbbbb', observation_location_id: @observation_location.id }, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得_observation_location_idパラメタ不正" do
    get weather_requests_url, params: { start_date: '2022-01-01', end_date: '2022-01-01', observation_location_id: @observation_location.id + 1 }, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得_終了日のが開始日より過去" do
    get weather_requests_url, params: { start_date: '2022-01-02', end_date: '2022-01-01', observation_location_id: @observation_location.id }, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal 0, json_response.length
  end

  test "観測地点一覧取得" do
    Sidekiq::Testing.fake!
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    get weather_requests_url, params: { start_date: '2022-01-01', end_date: '2022-01-01', observation_location_id: @ol_tengoku.id }, as: :json
    assert_response :success
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    json_response = JSON.parse( response.body )
    assert_equal 24, json_response.length
    assert_equal @measurement_tengoku_one.id, json_response.first['measurement_id']
  end

  test "観測地点一覧取得_欠損" do
    Sidekiq::Testing.fake!
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    weather_requests( :tengoku_tweten_four ).destroy
    get weather_requests_url, params: { start_date: '2022-01-01', end_date: '2022-01-01', observation_location_id: @ol_tengoku.id }, as: :json
    assert_response :success
    assert_equal 1, Sidekiq::Queues["queue_manager"].size
    Sidekiq::Queues["queue_manager"].clear
    json_response = JSON.parse( response.body )
    assert_equal 23, json_response.length
    assert_equal @measurement_tengoku_one.id, json_response.first['measurement_id']
  end
end
