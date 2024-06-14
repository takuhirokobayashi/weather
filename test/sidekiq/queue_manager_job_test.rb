require 'test_helper'
require 'sidekiq/testing'
require 'minitest/mock'

class QueueManagerJobTest < ActiveSupport::TestCase
  fixtures :app_states, :observation_locations, :weather_stations

  def setup
    @observation_location = observation_locations( :hutuu )
    @weather_station = weather_stations( :hutuu )
    @start_date = "2022-01-01"
    @end_date = "2022-01-14"
  end

  def test_AppStateがdown
    Sidekiq::Testing.inline!
    Sidekiq::Queues["queue_manager"].clear
    mock_job = Minitest::Mock.new
    mock_job.expect( :perform_async, nil, [@observation_location.id, @weather_station.id, '2022-01-01', '2022-01-14'] )

    JmaWeatherRequestJob.stub( :set, -> ( options ) { mock_job } ) do
      QueueManagerJob.perform_async( @observation_location.id, @start_date, @end_date )
    end

    exception = assert_raises( MockExpectationError ) {
      mock_job.verify
    }
    assert_equal exception.message, "expected perform_async(#{@observation_location.id}, #{@weather_station.id}, \"2022-01-01\", \"2022-01-14\") => nil"
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_AppStateがout_of_service
    Sidekiq::Testing.inline!
    AppState.set_out_of_service
    Sidekiq::Queues["queue_manager"].clear
    mock_job = Minitest::Mock.new
    mock_job.expect( :perform_async, nil, [@observation_location.id, @weather_station.id, '2022-01-01', '2022-01-14'] )

    JmaWeatherRequestJob.stub( :set, -> ( options ) { mock_job } ) do
      QueueManagerJob.perform_async( @observation_location.id, @start_date, @end_date )
    end

    exception = assert_raises( MockExpectationError ) {
      mock_job.verify
    }
    assert_equal exception.message, "expected perform_async(#{@observation_location.id}, #{@weather_station.id}, \"2022-01-01\", \"2022-01-14\") => nil"
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_observation_location_idに該当するレコードが無い場合は例外が発生するか
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Testing.inline! do
      assert_equal 0, Sidekiq::Queues["queue_manager"].size
      assert_raises( ActiveRecord::RecordNotFound ) do
        QueueManagerJob.perform_async( @observation_location.id + 1, @start_date, @end_date )
      end
      assert_equal 0, Sidekiq::Queues["queue_manager"].size
    end
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_start_dateに問題がある場合は例外が発生するか
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Testing.inline! do
      assert_equal 0, Sidekiq::Queues["queue_manager"].size
      assert_raises( Date::Error, ArgumentError ) do
        QueueManagerJob.perform_async( @observation_location.id, '2022-01-aa', @end_date )
      end
      assert_equal 0, Sidekiq::Queues["queue_manager"].size
    end
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_end_dateに問題がある場合は例外が発生するか
    AppState.set_active!
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Testing.inline! do
      assert_equal 0, Sidekiq::Queues["queue_manager"].size
      assert_raises( Date::Error, ArgumentError ) do
        QueueManagerJob.perform_async( @observation_location.id, @start_date, '2022-01-aa' )
      end
      assert_equal 0, Sidekiq::Queues["queue_manager"].size
    end
    Sidekiq::Queues["queue_manager"].clear
  end

  def test_日付が一日で重なっている観測所は対象外か
    AppState.set_active!
    Sidekiq::Testing.inline!
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Queues["jma_request"].clear
    observation_location = observation_locations( :anoyo )
    ityoume = weather_stations( :ityoume )
    santyoume = weather_stations( :santyoume )
    mock_job = Minitest::Mock.new
    mock_job.expect( :perform_async, nil, [observation_location.id, ityoume.id, '2022-01-01', '2022-01-07'] )
    mock_job.expect( :perform_async, nil, [observation_location.id, santyoume.id, '2022-01-08', '2022-01-14'] )

    JmaWeatherRequestJob.stub( :set, -> ( options ) { mock_job } ) do
      QueueManagerJob.perform_async( observation_location.id, @start_date, @end_date )
    end
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Queues["jma_request"].clear
  end

  def test_内部ジョブが一つだけ投げられる
    AppState.set_active!
    Sidekiq::Testing.inline!
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Queues["jma_request"].clear
    mock_job = Minitest::Mock.new
    mock_job.expect( :perform_async, nil, [@observation_location.id, @weather_station.id, '2022-01-01', '2022-01-14'] )

    JmaWeatherRequestJob.stub( :set, -> ( options ) { mock_job } ) do
      QueueManagerJob.perform_async( @observation_location.id, @start_date, @end_date )
    end
    assert mock_job.verify
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Queues["jma_request"].clear
  end

  def test_内部ジョブが二つに分かれる
    AppState.set_active!
    Sidekiq::Testing.inline!
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Queues["jma_request"].clear
    mock_job = Minitest::Mock.new
    mock_job.expect( :perform_async, nil, [@observation_location.id, @weather_station.id, '2022-01-01', '2022-01-14'] )
    mock_job.expect( :perform_async, nil, [@observation_location.id, @weather_station.id, '2022-01-15', '2022-01-16'] )

    # :perform_async, -> ( observation_location_id, weather_station_id, start_date_s, end_date_s ) {
    #   mock_job.perform_async( observation_location_id, weather_station_id, start_date_s, end_date_s )
    # }
    JmaWeatherRequestJob.stub( :set, -> ( options ) { mock_job } ) do
      QueueManagerJob.perform_async( @observation_location.id, @start_date, '2022-01-16' )
    end
    assert mock_job.verify
    Sidekiq::Queues["queue_manager"].clear
    Sidekiq::Queues["jma_request"].clear
  end
end
