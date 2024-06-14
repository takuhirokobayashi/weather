## https://www.data.jma.go.jp/risk/obsdl/top/help3.html
class Measurement < ApplicationRecord
  belongs_to :weather_station, optional: true
  belongs_to :wind_direction
  belongs_to :weather_symbol
  has_one :weather_request

  validates :weather_station, presence: true
  validates :observation_date_time, presence: true
  validates :temperature, numericality: { allow_nil: true }
  validates :temperature_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :temperature_homogeneity_number, numericality: { only_integer: true }
  validates :precipitation, numericality: { allow_nil: true }
  validates :precipitation_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :precipitation_homogeneity_number, numericality: { only_integer: true }
  validates :snowfall, numericality: { allow_nil: true, only_integer: true }
  validates :snowfall_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :snowfall_homogeneity_number, numericality: { only_integer: true }
  validates :snow_depth, numericality: { allow_nil: true, only_integer: true }
  validates :snow_depth_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :snow_depth_homogeneity_number, numericality: { only_integer: true }
  validates :sunshine_duration, numericality: { allow_nil: true }
  validates :sunshine_duration_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :sunshine_duration_homogeneity_number, numericality: { only_integer: true }
  validates :wind_speed, numericality: { allow_nil: true }
  validates :wind_speed_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :wind_direction_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :wind_direction_homogeneity_number, numericality: { only_integer: true }
  validates :solar_radiation, numericality: { allow_nil: true, only_integer: true }
  validates :solar_radiation_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :solar_radiation_homogeneity_number, numericality: { only_integer: true }
  validates :local_atmospheric_pressure, numericality: { allow_nil: true }
  validates :local_atmospheric_pressure_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :local_atmospheric_pressure_homogeneity_number, numericality: { only_integer: true }
  validates :sea_atmospheric_pressure, numericality: { allow_nil: true }
  validates :sea_atmospheric_pressure_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :sea_atmospheric_pressure_homogeneity_number, numericality: { only_integer: true }
  validates :relative_humidity, numericality: { allow_nil: true, only_integer: true }
  validates :relative_humidity_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :relative_humidity_homogeneity_number, numericality: { only_integer: true }
  validates :vapor_pressure, numericality: { allow_nil: true }
  validates :vapor_pressure_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :vapor_pressure_homogeneity_number, numericality: { only_integer: true }
  validates :dew_point_temperature, numericality: { allow_nil: true }
  validates :dew_point_temperature_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :dew_point_temperature_homogeneity_number, numericality: { only_integer: true }
  validates :weather_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :weather_homogeneity_number, numericality: { only_integer: true }
  validates :cloud_cover, numericality: {
    allow_nil: true, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  }
  validates :cloud_cover_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :cloud_cover_homogeneity_number, numericality: { only_integer: true }
  validates :visibility, numericality: { allow_nil: true }
  validates :visibility_quality_information, inclusion: [0, 1, 2, 4, 5, 8]
  validates :visibility_homogeneity_number, numericality: { only_integer: true }

  def self.store_data( observation_location, weather_station_id, weather_requests, start_date, end_date )
    uri = URI( Constants::JAPAN_METEOROLOGICAL_AGENCY )
    http = Net::HTTP.new( uri.host, uri.port )
    http.use_ssl = true

    php_session = fetch_php_session( http, weather_requests )
    download_data( observation_location, weather_station_id, weather_requests, start_date, end_date, http, php_session )
  end

  private

  def self.fetch_php_session( http, weather_requests )
    logger.info "Request GET #{Constants::JMA_SITE_DOWNLOAD_TOP}"
    request_time = Time.zone.now
    response = http.request_get( Constants::JMA_SITE_DOWNLOAD_TOP )
    unless '200' == response.code
      error_message = I18n.t( 'errors.messages.get_weather_station_error', response_code: response.code )
      set_error_weather_request( weather_requests, error_message, request_time )
      raise JmaHttpResponseError.new( error_message )
    end

    doc = Nokogiri::HTML.parse( response.body )
    if doc.at( '#sid' ).nil? || doc.at( '#sid' )['value'].nil?
      error_message = I18n.t( 'errors.messages.php_session_not_found' )
      set_error_weather_request( weather_requests, error_message, request_time )
      raise JmaHttpResponseError.new( error_message )
    end

    doc.at( '#sid' )['value']
  end

  def self.download_data( observation_location, weather_station_id, weather_requests, start_date, end_date, http, php_session )
    params = URI.encode_www_form(
      {
        PHPSESSID: php_session,
        csvFlag: 1,
        ymdLiteral: 1,
        downloadFlag: 'true',
        aggrgPeriod: 9,
        interAnnualFlag: 1,
        jikantaiFlag: 0,
        ymdList: [
          start_date.year.to_s,
          end_date.year.to_s,
          start_date.month.to_s,
          end_date.month.to_s,
          start_date.day.to_s,
          end_date.day.to_s
        ].to_json,
        ## 時間を指定出来るようで出来ないので固定
        jikantaiList: [1,24].to_json,
        stationNumList: [observation_location.stid].to_json,
        elementNumList: [
          ['201', ''],
          ['101', ''],
          ['503', ''],
          ['501', ''],
          ['401', ''],
          ['301', ''],
          ['610', ''],
          ['601', ''],
          ['602', ''],
          ['605', ''],
          ['604', ''],
          ['612', ''],
          ['703', ''],
          ['607', ''],
          ['704', '']
        ].to_json,
        optionNumList: [].to_json,
        rmkFlag: 1,
        disconnectFlag: 1,
        youbiFlag: 0,
        fukenFlag: 0,
        kijiFlag: 0,
        huukouFlag: 0
      }
    )
    logger.info "Request GET #{Constants::JMA_SITE_DOWNLOAD_MESUREMENT}"
    request_time = Time.zone.now
    response = http.request_post( Constants::JMA_SITE_DOWNLOAD_MESUREMENT, params )

    handle_download_response( weather_station_id, weather_requests, start_date, end_date, response, request_time )
  end

  def self.handle_download_response( weather_station_id, weather_requests, start_date, end_date, response, request_time )
    validate_response( response, weather_requests, request_time )

    download_csv = CSV.parse( NKF.nkf( '-w -S -x', response.body ) )
    download_time_row = download_csv.shift
    blank_row = download_csv.shift
    header_1 = download_csv.shift
    header_2 = download_csv.shift
    header_3 = download_csv.shift
    header_4 = download_csv.shift

    handle_csv_row( weather_station_id, weather_requests, start_date, end_date, download_csv, request_time )
  end

  def self.validate_response( response, weather_requests, request_time )
    unless '200' == response.code
      error_message = I18n.t( 'errors.messages.get_weather_station_error', response_code: response.code )
      set_error_weather_request( weather_requests, error_message, request_time )
      raise JmaHttpResponseError.new( error_message )
    end

    unless response.content_type.include?( 'text/x-comma-separated-values' )
      raise JmaTooManyRequests.new
    end
  end

  def self.handle_csv_row( weather_station_id, weather_requests, start_date, end_date, data, request_time )
    delete_ids = []
    data.each do |row|
      validate_csv_row( row, weather_station_id, start_date, end_date, weather_requests, request_time )
      weather_requests, weather_request = find_weather_request( weather_requests, row, weather_station_id, start_date, end_date, request_time )
      delete_ids.push( weather_request.id )
      next if weather_request.finished?
      process_csv_row( weather_station_id, weather_request, row, request_time )
    end

    weather_requests = weather_requests.delete_if {|weather_request| delete_ids.include?( weather_request.id ) }
    check_for_remaining_requests( weather_requests, weather_station_id, start_date, end_date, request_time )
  end

  def self.validate_csv_row( row, weather_station_id, start_date, end_date, weather_requests, request_time )
    if row.nil? || ( ! row.is_a?( Array ) ) || 52 != row.length
      error_message = I18n.t(
        'errors.messages.insufficient_columns',
        weather_station_id: weather_station_id, start_date: start_date, end_date: end_date
      )
      set_error_weather_request( weather_requests, error_message, request_time )
      raise InvalidMeasurementCsvFileError.new( error_message )
    end
  end

  def self.find_weather_request( weather_requests, row, weather_station_id, start_date, end_date, request_time )
    measurement_datetime = parse_datetime( row[0]&.strip, weather_station_id, start_date, end_date, weather_requests, request_time )
    idx = weather_requests.find_index{|weather_request| measurement_datetime == weather_request.observation_date_time }
    if idx.nil?
      error_message = I18n.t(
        'errors.messages.datetime_issue',
        weather_station_id: weather_station_id, start_date: start_date, end_date: end_date
      )
      set_error_weather_request( weather_requests, error_message, request_time )
      raise InvalidMeasurementCsvFileError.new( error_message )
    end

    weather_request = weather_requests[idx]
    weather_request.request_time = request_time

    [weather_requests, weather_request]
  end

  def self.parse_datetime( datetime_str, weather_station_id, start_date, end_date, weather_requests, request_time )
    Time.zone.strptime( datetime_str, "%Y/%m/%d %H:%M:%S" )
  rescue TypeError, Date::Error, ArgumentError => ex
    error_message = I18n.t(
      'errors.messages.datetime_issue',
      weather_station_id: weather_station_id, start_date: start_date, end_date: end_date
    )
    set_error_weather_request( weather_requests, error_message, request_time )
    raise InvalidMeasurementCsvFileError.new( error_message )
  end

  def self.process_csv_row( weather_station_id, weather_request, row, request_time )
    ActiveRecord::Base.transaction do
      measurement = update_from_row( weather_station_id, weather_request.observation_date_time, row )
      unless measurement.errors.empty?
        error_message = I18n.t(
          'errors.messages.validation_error',
          weather_station_id: weather_station_id,
          observation_date_time: weather_request.observation_date_time,
          detail: measurement.errors.full_messages.join( ' ' )
        )
        weather_request.set_error( error_message )
        raise InvalidMeasurementCsvFileError.new( error_message )
      end
      weather_request.set_successful( measurement.id, request_time )
      wr_arel_t = WeatherRequest.arel_table
      ActionCable.server.broadcast(
        "weather_request_channel_#{weather_request.observation_location_id}",
        WeatherRequest.list_select_joins.where( wr_arel_t[:id].eq( weather_request.id ) ).as_json
      )
    end
  end

  def self.update_from_row( weather_station_id, observation_date_time, row )
    measurement = Measurement.find_or_initialize_by(
      weather_station_id: weather_station_id,
      observation_date_time: observation_date_time
    )
    compass_direction = row[22]&.strip
    compass_direction = '風向設定無し' if compass_direction.nil?
    wind_direction = WindDirection.find_by!( compass_direction: compass_direction )
    weather_code = row[43]&.strip
    weather_code = 999 if weather_code.nil?
    weather_symbol = WeatherSymbol.find_by!( weather_code: weather_code )

    measurement.assign_attributes(
      temperature: row[1]&.strip,
      temperature_quality_information: row[2]&.strip,
      temperature_homogeneity_number: row[3]&.strip,
      precipitation: row[4]&.strip,
      precipitation_no_phenomena_information: row[5]&.strip.present? ? row[5].strip : false,
      precipitation_quality_information: row[6]&.strip,
      precipitation_homogeneity_number: row[7]&.strip,
      snowfall: row[8]&.strip,
      snowfall_no_phenomena_information: row[9]&.strip.present? ? row[9].strip : false,
      snowfall_quality_information: row[10]&.strip,
      snowfall_homogeneity_number: row[11]&.strip,
      snow_depth: row[12]&.strip,
      snow_depth_no_phenomena_information: row[13]&.strip.present? ? row[13].strip : false,
      snow_depth_quality_information: row[14]&.strip,
      snow_depth_homogeneity_number: row[15]&.strip,
      sunshine_duration: row[16]&.strip,
      sunshine_duration_no_phenomena_information: row[17]&.strip.present? ? row[17].strip : false,
      sunshine_duration_quality_information: row[18]&.strip,
      sunshine_duration_homogeneity_number: row[19]&.strip,
      wind_speed: row[20]&.strip,
      wind_speed_quality_information: row[21]&.strip,
      wind_direction: wind_direction,
      wind_direction_quality_information: row[23]&.strip,
      wind_direction_homogeneity_number: row[24]&.strip,
      solar_radiation: row[25]&.strip,
      solar_radiation_quality_information: row[26]&.strip,
      solar_radiation_homogeneity_number: row[27]&.strip,
      local_atmospheric_pressure: row[28]&.strip,
      local_atmospheric_pressure_quality_information: row[29]&.strip,
      local_atmospheric_pressure_homogeneity_number: row[30]&.strip,
      sea_atmospheric_pressure: row[31]&.strip,
      sea_atmospheric_pressure_quality_information: row[32]&.strip,
      sea_atmospheric_pressure_homogeneity_number: row[33]&.strip,
      relative_humidity: row[34]&.strip,
      relative_humidity_quality_information: row[35]&.strip,
      relative_humidity_homogeneity_number: row[36]&.strip,
      vapor_pressure: row[37]&.strip,
      vapor_pressure_quality_information: row[38]&.strip,
      vapor_pressure_homogeneity_number: row[39]&.strip,
      dew_point_temperature: row[40]&.strip,
      dew_point_temperature_quality_information: row[41]&.strip,
      dew_point_temperature_homogeneity_number: row[42]&.strip,
      weather_symbol: weather_symbol,
      weather_quality_information: row[44]&.strip,
      weather_homogeneity_number: row[45]&.strip,
      cloud_cover: row[46]&.strip,
      cloud_cover_quality_information: row[47]&.strip,
      cloud_cover_homogeneity_number: row[48]&.strip,
      visibility: row[49]&.strip,
      visibility_quality_information: row[50]&.strip,
      visibility_homogeneity_number: row[51]&.strip
    )

    measurement.save
    measurement
  end

  def self.check_for_remaining_requests( weather_requests, weather_station_id, start_date, end_date, request_time )
    if 0 < weather_requests.length
      error_message = I18n.t(
        'errors.messages.insufficient_rows',
        weather_station_id: weather_station_id, start_date: start_date, end_date: end_date
      )
      set_error_weather_request( weather_requests, error_message, request_time )
      raise InvalidMeasurementCsvFileError.new( error_message )
    end
  end

  def self.set_error_weather_request( weather_requests, error_message, request_time = nil )
    weather_requests.each do |weather_request|
      weather_request.request_time = request_time unless request_time.nil?
      weather_request.set_error( error_message )
    end
  end
end
