class JmaWeatherRequestJob
  include Sidekiq::Job
  sidekiq_options retry: 0, queue: 'jma_request'

  def perform( observation_location_id, weather_station_id, start_date_s, end_date_s )
    return if AppState.down? || AppState.out_of_service?

    observation_location = ObservationLocation.find( observation_location_id )
    weather_station = weather_station_id ? WeatherStation.find( weather_station_id ) : nil
    start_date = Date.parse( start_date_s )
    end_date = Date.parse( end_date_s )
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day

    weather_requests = generate_weather_requests( observation_location_id, weather_station_id, start_time, end_time )

    if AppState.overloaded?
      weather_requests.each do |weather_request|
        if ! weather_request.finished? && ! weather_request.cancelled?
          weather_requests.set_cancell
          weather_requests.save
        end
      end
      return
    end

    return if weather_requests.any?( &:cancelled? )

    store_weather_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
  end

  private

  def generate_weather_requests( observation_location_id, weather_station_id, start_time, end_time )
    weather_requests = []
    start_time.to_i.step( end_time.to_i, 1.hour.to_i ) do |current_sec|
      observation_date_time = Time.zone.at( current_sec )
      weather_request = WeatherRequest.find_or_initialize_by(
        observation_location_id: observation_location_id,
        observation_date_time: observation_date_time
      )
      weather_request = process_weather_request( weather_request, weather_station_id )
      weather_requests.push( weather_request )
    end

    weather_requests
  end

  def process_weather_request( weather_request, weather_station_id )
    if weather_request.new_record?
      weather_request = handle_new_request( weather_request, weather_station_id )
    else
      weather_request = handle_existing_request( weather_request )
    end

    weather_request.retry_count += 1 unless weather_request.cancelled?
    weather_request.request_time = Time.zone.now
    weather_request.save

    weather_request
  end

  def handle_new_request( weather_request, weather_station_id )
    if weather_station_id.nil?
      weather_request.set_none_record
    else
      if AppState.overloaded?
        weather_request.set_cancell
      else
        weather_request.set_initial
      end
    end

    weather_request
  end

  def handle_existing_request( weather_request )
    unless weather_request.cancelled? || weather_request.finished?
      weather_request.set_retry
    end

    weather_request
  end

  def store_weather_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
    Measurement.store_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
  rescue InvalidMeasurementCsvFileError, JmaHttpResponseError => ex
    AppState.set_out_of_service
    raise ex
  rescue JmaTooManyRequests => ex
    AppState.set_overloaded
  end 
end
