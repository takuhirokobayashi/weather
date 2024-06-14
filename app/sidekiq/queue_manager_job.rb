class QueueManagerJob
  include Sidekiq::Job
  sidekiq_options retry: 0, queue: 'queue_manager'

  MAX_PERIOD_DAYS = 14

  def perform( observation_location_id, start_date_s, end_date_s )
    return if AppState.down? || AppState.out_of_service?

    start_date = Date.parse( start_date_s )
    end_date = Date.parse( end_date_s )
    observation_location = ObservationLocation.find( observation_location_id )

    weather_stations = WeatherStation.exist_station( observation_location, start_date, end_date )
    .order( :observation_start_date ).to_a
    weather_stations = filter_overlapping_stations( weather_stations )

    process_periods( observation_location_id, weather_stations, start_date, end_date )
  end

  private

  def filter_overlapping_stations( weather_stations )
    ## 現行該当データは無いが
    ## 同日で前か後ろのレコードに日付が重なっていた場合、
    ## どちらに観測データを振り分けていいか判断が付かないので同日データを対象外とする
    weather_stations.reject.with_index do |station, i|
      same_day = station.observation_start_date == station.observation_end_date
      overlaps = ( i < weather_stations.length - 1 && station.observation_end_date == weather_stations[i + 1].observation_start_date ) ||
                 ( 0 < i && weather_stations[i - 1].observation_end_date == station.observation_start_date )
      same_day && overlaps
    end
  end

  def process_periods( observation_location_id, weather_stations, start_date, end_date )
    current_start_date = start_date
    weather_station = weather_stations.shift
    delay_seconds = 0

    while current_start_date <= end_date
      weather_station_id = nil
      current_end_date = [current_start_date + ( MAX_PERIOD_DAYS - 1 ).days, end_date].min
      record_end_date = nil

      if weather_station
        record_end_date = weather_station.observation_end_date
        next_weather_station = weather_stations.first
        if next_weather_station && weather_station.observation_end_date &&
          weather_station.observation_end_date == next_weather_station.observation_start_date
          record_end_date -= 1.day
        end

        if current_start_date < weather_station.observation_start_date
          current_end_date = [weather_station.observation_start_date - 1.day, current_end_date].min
        else
          weather_station_id = weather_station.id
          current_end_date = [record_end_date, current_end_date].compact.min
        end
      end

      JmaWeatherRequestJob.set( wait: ( delay_seconds * 5 ).seconds ).perform_async( observation_location_id, weather_station_id, current_start_date.to_s, current_end_date.to_s )
      current_start_date = current_end_date + 1.day
      delay_seconds += 1

      if weather_station && record_end_date && record_end_date < current_start_date
        weather_station = weather_stations.shift
      end
    end
  end
end
