class WeatherRequestsController < ApplicationController
  def index
    @weather_requests = []

    if required_params_missing?
      render json: @weather_requests
      return
    end

    start_date, end_date, observation_location = parse_params

    if start_date.nil? || end_date.nil? || observation_location.nil?
      render json: @weather_requests
      return
    end

    if start_date > end_date
      render json: @weather_requests
      return
    end

    ### 現実的な日取りを設定してもらいたいので
    ### 気象庁の観測開始日(気象庁(not AMEDAS)として観測した値を有効な値とした日)意識した方がいいかも
    ### 場合によっては足切り

    fetch_or_enqueue_weather_requests( start_date, end_date, observation_location )

    render json: @weather_requests
  end

  private

  def required_params_missing?
    ! params[:start_date].present? || ! params[:end_date].present? || ! params[:observation_location_id].present?
  end

  def parse_params
    start_date = Date.parse( params[:start_date] ) rescue nil
    end_date = Date.parse( params[:end_date] ) rescue nil
    observation_location = ObservationLocation.find_by( id: params[:observation_location_id] )

    [start_date, end_date, observation_location]
  end

  def fetch_or_enqueue_weather_requests( start_date, end_date, observation_location )
    number_of_days = ( end_date - start_date ).to_i + 1
    start_time = Time.zone.local( start_date.year, start_date.month, start_date.day ) + 1.hour
    end_time = Time.zone.local( end_date.year, end_date.month, end_date.day ) + 1.day

    wr_arel_t = WeatherRequest.arel_table
    where_str = wr_arel_t[:observation_date_time].gteq( start_time ).and(
      wr_arel_t[:observation_date_time].lteq( end_time )
    )
    measurement_id_exist_str = wr_arel_t[:measurement_id].not_eq( nil )

    weather_request_count = WeatherRequest.where( observation_location: observation_location )
    .where( where_str ).where( measurement_id_exist_str ).count
    @weather_requests = WeatherRequest
    .list_select_joins
    .where( observation_location: observation_location )
    .where( where_str ).order( :observation_date_time )
    .order( wr_arel_t[:observation_date_time] )
    if ( number_of_days * 24 ) != weather_request_count
      QueueManagerJob.perform_async( observation_location.id, start_date.to_s, end_date.to_s )
    end
  end
end
