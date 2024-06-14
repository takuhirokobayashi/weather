class WeatherRequestChannel < ApplicationCable::Channel
  def subscribed
    observation_location_id = params[:observation_location_id]
    stream_from "weather_request_channel_#{observation_location_id}"
  end

  def unsubscribed
  end
end
