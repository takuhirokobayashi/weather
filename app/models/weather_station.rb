## https://www.data.jma.go.jp/obd/stats/data/mdrr/man/kansoku_gaiyou.html
## https://www.data.jma.go.jp/obd/stats/data/mdrr/man/amdmasterindex4_format.pdf
class WeatherStation < ApplicationRecord
  belongs_to :observation_location, optional: true
  has_many :measurements

  validates :station_number, numericality: { only_integer: true }
  validate :validate_coordinate
  validates :height_above_sea_level, numericality: { allow_nil: true, only_integer: true }
  validates :height_of_anemometer, numericality: { allow_nil: true }
  validate :validate_coordinate_snow
  validates :height_above_sea_level_snow, numericality: { allow_nil: true, only_integer: true }
  validates :sunshine_duration_measurement_summary, inclusion: ['0', '1', '2']
  validates :observation_start_date, presence: true
  validate :validate_observation_period
  validates :old_station_number, numericality: { only_integer: true }
  validates :precipitation_statistics_link, inclusion: ['0', '1']
  validates :wind_statistics_link, inclusion: ['0', '1', '4', '5']
  validates :temperature_statistics_link, inclusion: ['0', '1', '4', '5']
  validates :sunshine_duration_statistics_link, inclusion: ['0', '1', '4', '5', '6', '7']
  validates :snow_depth_statistics_link, inclusion: ['0', '1']
  validates :humidity_statistics_link, inclusion: ['0', '1']

  scope :exist_station, ->( observation_location, start_date, end_date ) {
    ws_arel_t = WeatherStation.arel_table
    where_str = ws_arel_t[:observation_start_date].lteq( end_date ).and(
      ws_arel_t[:observation_end_date].gteq( start_date ).or(
        ws_arel_t[:observation_end_date].eq( nil )
      )
    )
    where( observation_location: observation_location ).where( where_str )
  }

  def self.get_list
    uri = URI( Constants::JAPAN_METEOROLOGICAL_AGENCY )
    http = Net::HTTP.new( uri.host, uri.port )
    http.use_ssl = true

    logger.info "Request GET #{Constants::JMA_SITE_AME_MASTER}"
    response = http.request_get( Constants::JMA_SITE_AME_MASTER )

    handle_response( response )
  end

  private

  def self.handle_response( response )
    unless '200' == response.code
      raise JmaHttpResponseError.new(
        I18n.t( 'errors.messages.get_weather_station_error', response_code: response.code )
      )
    end

    amedas_csv = CSV.parse( NKF.nkf( '-w -S -x', response.body ) )
    header_1 = amedas_csv.shift
    header_2 = amedas_csv.shift

    check_list_date( amedas_csv )

    amedas_csv.each do |row|
      process_weather_station( row )
    end
  end

  def self.check_list_date( amedas_csv )
    station_numbers = amedas_csv.map{|row| row[0].strip }.sort.uniq
    station_numbers.each do |station_number|
      date_list = collect_date_list( amedas_csv, station_number )
      validate_date_list( station_number, date_list )
    end
  end

  def self.collect_date_list( amedas_csv, station_number )
    amedas_csv.filter{
      |row| row[0].strip == station_number
    }.collect{|row|
      {
        station_number: station_number,
        start_date: parse_date( row[23] ),
        end_date: parse_end_date( row[24] )
      }
    }.sort_by{|entry|
      [entry[:start_date], entry[:end_date]]
    }
  end

  def self.parse_date( date_string )
    begin
      Date.parse( date_string.strip )
    rescue => ex
    end
  end

  def self.parse_end_date( end_date_string )
    begin
      '9999-99-99' == end_date_string.strip ? Date.new( 9999, 12, 31 ) : Date.parse( end_date_string.strip )
    rescue => ex
    end
  end

  def self.validate_date_list( station_number, date_list )
    date_list.each_cons( 2 ) do |current, next_data|
      start_date_current = current[:start_date]
      end_date_current = current[:end_date]
      start_date_next = next_data[:start_date]
      end_date_next = next_data[:end_date]

      if end_date_current < start_date_current
        raise InvalidAmedasFileError.new(
          I18n.t( 'errors.messages.enddate_before_startdate', station_number: current[:station_number] )
        )
      end

      if start_date_next < end_date_current
        raise InvalidAmedasFileError.new(
          I18n.t( 'errors.messages.overlapping_period', station_number: current[:station_number] )
        )
      end
    end
  end

  def self.process_weather_station( row )
    station_number = row[0].strip
    utf8_zenkaku_space = "\xE3\x80\x80"
    station_name = row[1].gsub( Regexp.new( utf8_zenkaku_space ), ' ' ).strip
    station_name_snow = row[4].gsub( Regexp.new( utf8_zenkaku_space ), ' ' ).strip
    latitude_degrees, latitude_minutes = check_coordinate( station_number, row[7], 'errors.messages.invalid_coordinate' )
    longitude_degrees, longitude_minutes = check_coordinate( station_number, row[8], 'errors.messages.invalid_coordinate' )
    latitude_degrees_snow, latitude_minutes_snow = check_coordinate( station_number, row[13], 'errors.messages.invalid_coordinate' )
    longitude_degrees_snow, longitude_minutes_snow = check_coordinate( station_number, row[14], 'errors.messages.invalid_coordinate' )
    observation_start_date = Date.parse( row[23].strip )
    observation_end_date = '9999-99-99' != row[24].strip ? Date.parse( row[24].strip ) : nil

    weather_station = find_or_initialize_weather_station( station_number, observation_start_date, observation_end_date )

    weather_station.assign_attributes(
      station_name: station_name.presence,
      station_name_kana: row[2].strip.presence,
      station_name_romaji: row[3].strip.presence,
      snow_gauge_station_name: station_name_snow.presence,
      snow_gauge_station_name_kana: row[5].strip.presence,
      snow_gauge_station_name_romaji: row[6].strip.presence,
      latitude_degrees: latitude_degrees,
      latitude_minutes: latitude_minutes,
      longitude_degrees: longitude_degrees,
      longitude_minutes: longitude_minutes,
      height_above_sea_level: row[9].strip.presence,
      ### この部分特に明記無かった(意味的には不明)けど、入ってたから仕方ないので…
      height_of_anemometer: '/////' == row[10].strip ? nil : row[10].strip.presence,
      latitude_degrees_snow: latitude_degrees_snow,
      latitude_minutes_snow: latitude_minutes_snow,
      longitude_degrees_snow: longitude_degrees_snow,
      longitude_minutes_snow: longitude_minutes_snow,
      height_above_sea_level_snow: row[15].strip.presence,
      precipitation_measurement_summary: '1' == row[16].strip,
      wind_measurement_summary: '1' == row[17].strip,
      temperature_measurement_summary: '1' == row[18].strip,
      sunshine_duration_measurement_summary: row[19].strip,
      snow_depth_measurement_summary: '1' == row[20].strip,
      humidity_measurement_summary: '1' == row[22].strip,
      old_station_number: row[25].strip.presence,
      precipitation_statistics_link: row[26].strip.presence,
      wind_statistics_link: row[27].strip.presence,
      temperature_statistics_link: row[28].strip.presence,
      sunshine_duration_statistics_link: row[29].strip.presence,
      snow_depth_statistics_link: row[30].strip.presence,
      humidity_statistics_link: row[32].strip.presence
    )

    weather_station.save!
  end

  def self.find_or_initialize_weather_station( station_number, observation_start_date, observation_end_date )
    existing_station = WeatherStation.find_by(
      station_number: station_number,
      observation_start_date: observation_start_date,
      observation_end_date: nil
    )
  
    if existing_station
      existing_station.observation_end_date = observation_end_date
      existing_station
    else
      WeatherStation.find_or_initialize_by(
        station_number: station_number,
        observation_start_date: observation_start_date,
        observation_end_date: observation_end_date
      )
    end
  end

  def self.check_coordinate( station_number, lat_lng_str, error_message_key )
    lat_lng_str.strip!
    return [nil, nil] if lat_lng_str.empty?

    degrees = convert_degrees( lat_lng_str )
    minutes = convert_minutes( lat_lng_str )

    if degrees.nil? || minutes.nil?
      raise InvalidAmedasFileError.new(
        I18n.t( error_message_key, station_number: station_number )
      )
    end

    [degrees, minutes]
  end

  def self.convert_degrees( lat_lng_str )
    m = /(-?\d+)(\.(\d{3}))?/.match(lat_lng_str)
    return m[1].to_i if m

    nil
  end

  def self.convert_minutes( lat_lng_str )
    m = /-?\d+\.\d{3}/.match( lat_lng_str )
    return nil unless m

    Rational( m[0][-3..-1].to_i * 60, 1000 ).to_f.round( 1 )
  end

  def validate_coordinate
    unless ( latitude_degrees.nil? && latitude_minutes.nil? && longitude_degrees.nil? && longitude_minutes.nil? ) or
        ( latitude_degrees.present? && latitude_minutes.present? && longitude_degrees.present? && longitude_minutes.present? )
      errors.add( :base, :invalid_coordinate, station_number: station_number )
    end
  end

  def validate_coordinate_snow
    unless ( latitude_degrees_snow.nil? && latitude_minutes_snow.nil? && longitude_degrees_snow.nil? && longitude_minutes_snow.nil? ) or
        ( latitude_degrees_snow.present? && latitude_minutes_snow.present? && longitude_degrees_snow.present? && longitude_minutes_snow.present? )
      errors.add( :base, :invalid_coordinate_snow, station_number: station_number )
    end
  end

  def validate_observation_period
    unless small_start_date?
      errors.add( :base, :enddate_before_startdate, station_number: station_number )
    end

    if overlaps_with_existing_period?
      errors.add( :base, :overlapping_period, station_number: station_number )
    end
  end

  def small_start_date?
    return observation_end_date.nil? || observation_start_date <= observation_end_date
  end

  def overlaps_with_existing_period?
    return false if observation_start_date.nil?

    ws_arel_t = WeatherStation.arel_table

    overlapping_periods = WeatherStation.where.not( id: id || 0 ).where( station_number: station_number )
    if observation_end_date.nil?
      overlapping_periods = overlapping_periods
      .where( Arel::Nodes::Grouping.new(
        ws_arel_t[:observation_end_date].eq( nil ).or(
          ws_arel_t[:observation_end_date].gteq( observation_start_date + 1.day )
        )
      ) )
    else
      overlapping_periods = overlapping_periods
      .where.not( Arel::Nodes::Grouping.new(
        ws_arel_t[:observation_start_date].gteq( observation_end_date ).or(
          Arel::Nodes::Grouping.new(
            ws_arel_t[:observation_end_date].lteq( observation_start_date ).and(
              ws_arel_t[:observation_end_date].not_eq( nil )
            )
          )
        )
      ) )
    end

    overlapping_periods.exists?
  end
end
