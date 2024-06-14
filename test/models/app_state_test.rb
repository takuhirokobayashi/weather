require "test_helper"

class AppStateTest < ActiveSupport::TestCase
  test "Activeの設定と確認" do
    AppState.set_active
    app_state = AppState.first
    assert_equal 'Active', app_state.state

    assert AppState.active?
  end

  test "Downの設定と確認" do
    AppState.set_active

    AppState.set_down
    app_state = AppState.first
    assert_equal 'Down', app_state.state

    assert AppState.down?
  end

  test "Overloadedの設定と確認" do
    AppState.set_overloaded
    app_state = AppState.first
    assert_equal 'Overloaded', app_state.state

    assert AppState.overloaded?
  end

  test "Throttled Operationの設定と確認" do
    AppState.set_throttled_operation
    app_state = AppState.first
    assert_equal 'Throttled Operation', app_state.state

    assert AppState.throttled_operation?
  end

  test "OutOfServiceの設定と確認" do
    AppState.set_out_of_service
    app_state = AppState.first
    assert_equal 'OutOfService', app_state.state

    assert AppState.out_of_service?
  end

  test "OutOfService後のActiveの設定" do
    AppState.set_out_of_service

    AppState.set_active
    app_state = AppState.first
    assert_not_equal 'Active', app_state.state
  end

  test "OutOfService後のDownの設定" do
    AppState.set_out_of_service

    AppState.set_down
    app_state = AppState.first
    assert_not_equal 'Down', app_state.state
  end

  test "OutOfService後のOverloadedの設定" do
    AppState.set_out_of_service

    AppState.set_overloaded
    app_state = AppState.first
    assert_not_equal 'Overloaded', app_state.state
  end

  test "OutOfService後のThrottled Operationの設定" do
    AppState.set_out_of_service

    AppState.set_throttled_operation
    app_state = AppState.first
    assert_not_equal 'Throttled Operation', app_state.state
  end

  test "OutOfService後の強制Activeの設定" do
    AppState.set_out_of_service

    AppState.set_active!
    app_state = AppState.first
    assert_equal 'Active', app_state.state
  end
end
