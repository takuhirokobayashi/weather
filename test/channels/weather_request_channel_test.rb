require "test_helper"

class WeatherRequestChannelTest < ActionCable::Channel::TestCase
  test "サブスクライブして指定idで接続されているか" do
    subscribe observation_location_id: "1"
    assert subscription.confirmed?
    assert_has_stream "weather_request_channel_1"
  end
end
