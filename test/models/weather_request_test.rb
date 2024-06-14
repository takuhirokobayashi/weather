require "test_helper"

class WeatherRequestTest < ActiveSupport::TestCase
  fixtures :wind_directions, :weather_symbols, :weather_stations, :measurements, :observation_locations, :weather_requests

  setup do
    @observation_location = observation_locations( :negibozu )
  end

  test "initial scopeの確認" do
    status = WeatherRequest.initial.pluck( :status ).uniq
    assert_equal 1, status.length
    assert_equal 'initial', status[0]
  end

  test "cancelled scopeの確認" do
    status = WeatherRequest.cancelled.pluck( :status ).uniq
    assert_equal 1, status.length
    assert_equal 'cancelled', status[0]
  end

  test "retrying scopeの確認" do
    status = WeatherRequest.retrying.pluck( :status ).uniq
    assert_equal 1, status.length
    assert_equal 'retry', status[0]
  end

  test "errored scopeの確認" do
    status = WeatherRequest.errored.pluck( :status ).uniq
    assert_equal 1, status.length
    assert_equal 'error', status[0]
  end

  test "successful scopeの確認" do
    status = WeatherRequest.successful.pluck( :status ).uniq
    assert_equal 1, status.length
    assert_equal 'success', status[0]
  end

  test "none_record scopeの確認" do
    status = WeatherRequest.none_record.pluck( :status ).uniq
    assert_equal 1, status.length
    assert_equal 'none_record', status[0]
  end

  test "retry_cancelled_requestsの確認" do
    WeatherRequest.retry_cancelled_requests
    fix_weather_request = weather_requests( :cancelled )
    assert_equal 'retry', fix_weather_request.status
  end

  test "cancel_requestsの確認" do
    WeatherRequest.cancel_requests
    fix_weather_request = weather_requests( :initial )
    assert_equal 'cancelled', fix_weather_request.status
    fix_weather_request = weather_requests( :cancelled )
    assert_equal 'cancelled', fix_weather_request.status
  end

  test "set_errorの確認" do
    fix_weather_request = weather_requests( :initial )
    fix_weather_request.set_error( 'ほげほげ' )
    assert_equal 'error', fix_weather_request.status
    assert_equal 'ほげほげ', fix_weather_request.error_message
  end

  test "set_errorしない確認" do
    fix_weather_request = weather_requests( :error )
    fix_weather_request.set_error( 'ほげほげ' )
    assert_equal 'error', fix_weather_request.status
    assert_not_equal 'ほげほげ', fix_weather_request.error_message
  end

  test "set_successfulの確認" do
    fix_weather_request = weather_requests( :initial )
    measurement = measurements( :one )
    now = Time.zone.now
    fix_weather_request.set_successful( measurement.id, now )
    assert_equal 'success', fix_weather_request.status
    assert_not_nil fix_weather_request.success_time
    assert_equal measurement.id, fix_weather_request.measurement_id
  end

  test "none_queueing?の確認、両方あり" do
    assert_not WeatherRequest.none_queueing?
  end

  test "none_queueing?の確認、initialのみ" do
    WeatherRequest.retrying.delete_all
    assert_not WeatherRequest.none_queueing?
  end

  test "none_queueing?の確認、retryのみ" do
    WeatherRequest.initial.delete_all
    assert_not WeatherRequest.none_queueing?
  end

  test "none_queueing?の確認、両方なし" do
    WeatherRequest.initial.delete_all
    WeatherRequest.retrying.delete_all
    assert WeatherRequest.none_queueing?
  end

  test "set_initialの確認" do
    fix_weather_request = weather_requests( :retry )
    fix_weather_request.set_initial
    assert_equal 'initial', fix_weather_request.status
  end

  test "set_retryの確認" do
    fix_weather_request = weather_requests( :initial )
    fix_weather_request.set_retry
    assert_equal 'retry', fix_weather_request.status
  end

  test "set_cancellの確認" do
    fix_weather_request = weather_requests( :initial )
    fix_weather_request.set_cancell
    assert_equal 'cancelled', fix_weather_request.status
  end

  test "set_none_recordの確認" do
    fix_weather_request = weather_requests( :initial )
    fix_weather_request.set_none_record
    assert_equal 'none_record', fix_weather_request.status
  end

  test "cancelled?の確認" do
    fix_weather_request = weather_requests( :initial )
    assert_not fix_weather_request.cancelled?
    fix_weather_request = weather_requests( :cancelled )
    assert fix_weather_request.cancelled?
    fix_weather_request = weather_requests( :retry )
    assert_not fix_weather_request.cancelled?
    fix_weather_request = weather_requests( :error )
    assert_not fix_weather_request.cancelled?
    fix_weather_request = weather_requests( :success )
    assert_not fix_weather_request.cancelled?
    fix_weather_request = weather_requests( :none_record )
    assert_not fix_weather_request.cancelled?
  end

  test "finished?の確認" do
    fix_weather_request = weather_requests( :initial )
    assert_not fix_weather_request.finished?
    fix_weather_request = weather_requests( :cancelled )
    assert_not fix_weather_request.finished?
    fix_weather_request = weather_requests( :retry )
    assert_not fix_weather_request.finished?
    fix_weather_request = weather_requests( :error )
    assert fix_weather_request.finished?
    fix_weather_request = weather_requests( :success )
    assert fix_weather_request.finished?
    fix_weather_request = weather_requests( :none_record )
    assert fix_weather_request.finished?
  end

  test "list_select_joinsの確認" do
    fix_weather_request = weather_requests( :success )
    wr_arel_t = WeatherRequest.arel_table
    weather_request = WeatherRequest.list_select_joins.where( wr_arel_t[:id].eq( fix_weather_request.id ) ).first
    assert_not_nil weather_request.measurement_id
    measurement = measurements( :one )
    assert_equal measurement.temperature, weather_request.temperature
  end
end
