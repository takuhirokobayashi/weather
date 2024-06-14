require 'test_helper'
require 'sidekiq/testing'
require 'minitest/mock'

class JmaWeatherRequestJobTest < ActiveSupport::TestCase
  fixtures :app_states, :observation_locations, :weather_stations, :weather_requests

  def setup
    @observation_location = observation_locations( :hutuu )
    @tengoku = observation_locations( :tengoku )
    @weather_station = weather_stations( :hutuu )
    @start_date = "2022-01-01"
    @end_date = "2022-01-01"
    @start_date_date = Date.parse( @start_date )
    @end_date_date = Date.parse( @end_date )
    @start_time = Time.zone.local( @start_date_date.year, @start_date_date.month, @start_date_date.day ) + 1.hour
    @end_time = Time.zone.local( @end_date_date.year, @end_date_date.month, @end_date_date.day ) + 1.day
  end

  def test_AppStateがdown
    Sidekiq::Testing.inline!
    Sidekiq::Queues["jma_request"].clear
    mock = Minitest::Mock.new
    mock.expect( :generate_weather_requests, [], [@observation_location.id, @weather_station.id, @start_time, @end_time] )

    jma_weather_request_job = JmaWeatherRequestJob.new
    jma_weather_request_job.stub( :generate_weather_requests, mock ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id, @weather_station.id, @start_date, @end_date )
    end

    exception = assert_raises( MockExpectationError ) {
      mock.verify
    }
    assert_equal exception.message, "expected generate_weather_requests(#{@observation_location.id}, #{@weather_station.id}, #{@start_time.strftime( "%a, %d %b %Y %H:%M:%S.%9N %Z %:z" )}, #{@end_time.strftime( "%a, %d %b %Y %H:%M:%S.%9N %Z %:z" )}) => []"
    Sidekiq::Queues["jma_request"].clear
  end

  def test_AppStateがout_of_service
    Sidekiq::Testing.inline!
    AppState.set_out_of_service
    Sidekiq::Queues["jma_request"].clear
    mock = Minitest::Mock.new
    mock.expect( :generate_weather_requests, [], [@observation_location.id, @weather_station.id, @start_time, @end_time] )

    jma_weather_request_job = JmaWeatherRequestJob.new
    jma_weather_request_job.stub( :generate_weather_requests, mock ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id, @weather_station.id, @start_date, @end_date )
    end

    exception = assert_raises( MockExpectationError ) {
      mock.verify
    }
    assert_equal exception.message, "expected generate_weather_requests(#{@observation_location.id}, #{@weather_station.id}, #{@start_time.strftime( "%a, %d %b %Y %H:%M:%S.%9N %Z %:z" )}, #{@end_time.strftime( "%a, %d %b %Y %H:%M:%S.%9N %Z %:z" )}) => []"
    Sidekiq::Queues["jma_request"].clear
  end

  def test_observation_location_idに該当するレコードが無い場合は例外が発生するか
    Sidekiq::Testing.inline!
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    assert_raises( ActiveRecord::RecordNotFound ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id + 1, @weather_station.id, @start_date, @end_date )
    end
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_start_dateに問題がある場合は例外が発生するか
    Sidekiq::Testing.inline!
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    assert_raises( Date::Error, ArgumentError ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id, @weather_station.id, '2022-01-aa', @end_date )
    end
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_end_dateに問題がある場合は例外が発生するか
    Sidekiq::Testing.inline!
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    assert_raises( Date::Error, ArgumentError ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id, @weather_station.id, @start_date, '2022-01-aa' )
    end
    assert_equal 0, Sidekiq::Queues["queue_manager"].size
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_既存のレコードありの場合_キャンセルなし
    result_weather_requests = WeatherRequest
    .where( 'observation_date_time >= ? AND observation_date_time <= ?', @start_time, @end_time )
    Sidekiq::Testing.inline!
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    mock = Minitest::Mock.new
    mock.expect :store_data, nil do |observation_location, weather_station_id, weather_requests, start_date, end_date|
      @tengoku == observation_location &&
      @weather_station.id == weather_station_id &&
      result_weather_requests == weather_requests &&
      @start_date_date == start_date &&
      @end_date_date == end_date
    end

    Measurement.stub( :store_data, -> ( observation_location, weather_station_id, weather_requests, start_date, end_date ) {
      mock.store_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
    } ) do
      JmaWeatherRequestJob.perform_async( @tengoku.id, @weather_station.id, @start_date, @end_date )
    end
    mock.verify
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_既存のレコードありの場合_キャンセルあり
    WeatherRequest
    .where( 'observation_date_time >= ? AND observation_date_time <= ?', @start_time, @end_time )
    .update_all( status: 'cancelled', success_time: nil, retry_count: 0, measurement_id: nil )
    Sidekiq::Testing.inline!
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    mock = Minitest::Mock.new
    mock.expect :store_data, nil do |observation_location, weather_station_id, weather_requests, start_date, end_date|
      true
    end

    Measurement.stub( :store_data, -> ( observation_location, weather_station_id, weather_requests, start_date, end_date ) {
      mock.store_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
    } ) do
      JmaWeatherRequestJob.perform_async( @tengoku.id, @weather_station.id, @start_date, @end_date )
    end
    exception = assert_raises( MockExpectationError ) {
      mock.verify
    }
    assert_equal exception.message, "expected store_data(i) => nil"
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_新規にレコードを作る場合_観測所あり_overload中
    Sidekiq::Testing.inline!
    AppState.set_active!
    AppState.set_overloaded
    Sidekiq::Queues["queue_manager"].clear
    mock = Minitest::Mock.new
    mock.expect :store_data, nil do |observation_location, weather_station_id, weather_requests, start_date, end_date|
      tmp_hour = @start_time - 1.hour
      @observation_location == observation_location &&
      @weather_station.id == weather_station_id &&
      weather_requests.collect {|weather_request| @observation_location.id == weather_request.observation_location_id }.any? &&
      24.times.collect { tmp_hour += 1.hour } == weather_requests.collect {|weather_request| weather_request.observation_date_time }.sort &&
      weather_requests.collect {|weather_request| 'initial' == weather_request.status }.any? &&
      @start_date_date == start_date &&
      @end_date_date == end_date
    end

    Measurement.stub( :store_data, -> ( observation_location, weather_station_id, weather_requests, start_date, end_date ) {
      mock.store_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
    } ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id, @weather_station.id, @start_date, @end_date )
    end
    exception = assert_raises( MockExpectationError ) {
      mock.verify
    }
    assert_equal exception.message, "expected store_data(i) => nil"
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_新規にレコードを作る場合_観測所あり_overloadしてない
    Sidekiq::Testing.inline!
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    mock = Minitest::Mock.new
    mock.expect :store_data, nil do |observation_location, weather_station_id, weather_requests, start_date, end_date|
      tmp_hour = @start_time - 1.hour
      @observation_location == observation_location &&
      @weather_station.id == weather_station_id &&
      weather_requests.collect {|weather_request| @observation_location.id == weather_request.observation_location_id }.any? &&
      24.times.collect { tmp_hour += 1.hour } == weather_requests.collect {|weather_request| weather_request.observation_date_time }.sort &&
      weather_requests.collect {|weather_request| 'initial' == weather_request.status }.any? &&
      @start_date_date == start_date &&
      @end_date_date == end_date
    end

    Measurement.stub( :store_data, -> ( observation_location, weather_station_id, weather_requests, start_date, end_date ) {
      mock.store_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
    } ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id, @weather_station.id, @start_date, @end_date )
    end
    mock.verify
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_新規にレコードを作る場合_観測所なし
    Sidekiq::Testing.inline!
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    mock = Minitest::Mock.new
    mock.expect :store_data, nil do |observation_location, weather_station_id, weather_requests, start_date, end_date|
      tmp_hour = @start_time - 1.hour
      @observation_location == observation_location &&
      nil == weather_station_id &&
      weather_requests.collect {|weather_request| @observation_location.id == weather_request.observation_location_id }.any? &&
      24.times.collect { tmp_hour += 1.hour } == weather_requests.collect {|weather_request| weather_request.observation_date_time }.sort &&
      weather_requests.collect {|weather_request| 'none_record' == weather_request.status }.any? &&
      @start_date_date == start_date &&
      @end_date_date == end_date
    end

    Measurement.stub( :store_data, -> ( observation_location, weather_station_id, weather_requests, start_date, end_date ) {
      mock.store_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
    } ) do
      JmaWeatherRequestJob.perform_async( @observation_location.id, nil, @start_date, @end_date )
    end
    mock.verify
    Sidekiq::Queues["queue_manager"].clear
  end
end
