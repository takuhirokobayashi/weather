class ObservationLocation < ApplicationRecord
  has_many :region_observation_locations, dependent: :destroy
  has_many :regions, through: :region_observation_locations
  has_many :weather_stations
  has_many :weather_requests

  validates :stid, presence: true, uniqueness: true
  validates :stname, presence: true

  def self.get_list
    regions = Region.all
    regions.each do |region|
      create_or_update_locations_in_region( region )
    end
  end

  private

  def self.create_or_update_locations_in_region( region )
    uri = URI( Constants::JAPAN_METEOROLOGICAL_AGENCY )
    http = Net::HTTP.new( uri.host, uri.port )
    http.use_ssl = true

    params = URI.encode_www_form( pd: region.prid )
    logger.info "Request POST #{Constants::JMA_SITE_REGION_STATION}"
    response = http.request_post( Constants::JMA_SITE_REGION_STATION, params )

    handle_response( response, region )
  end

  def self.handle_response( response, region )
    unless '200' == response.code
      raise JmaHttpResponseError.new( I18n.t( 'errors.messages.get_observation_location_error', response_code: response.code ) )
    end

    doc = Nokogiri::HTML.parse( Constants::HTML_DUMMY_HEADER + response.body + Constants::HTML_DUMMY_FOOTER )
    map_pointers = doc.at( 'body' ).search( 'div' )[1]

    stid_list = Set.new
    map_pointers.search( 'div' ).each do |point|
      inner_div = point.search( 'div' )[0]
      next unless inner_div

      title, stid, stname, kansoku = extract_location_data( inner_div )
      next if stid.blank? || stname.blank? || '0' == kansoku || title.blank? || stid_list.include?( stid )

      info = extract_location_info( title )
      next unless info[:latitude_degrees] && info[:latitude_minutes] && info[:longitude_degrees] && info[:longitude_minutes]

      ## validationで設定しているが富士山問題があるのでここで明示的に弾く必要がある
      observation_location = ObservationLocation.where( stid: stid ).first
      unless observation_location.present?
        observation_location = ObservationLocation.new( stid: stid, stname: stname )
        observation_location.save!
      end
      stid_list.add( stid )

      region_observation_location = RegionObservationLocation
      .find_or_initialize_by( region: region, observation_location: observation_location )
      region_observation_location.save!

      ws_arel_t = WeatherStation.arel_table
      ## TITLEとCSVの座標が同じでも観測所名が微妙に違ったりするので座標のみで探す
      where_str = ws_arel_t[:observation_location_id].eq( nil ).and(
        Arel::Nodes::Grouping.new(
          ws_arel_t[:latitude_degrees].eq( info[:latitude_degrees] ).and(
            ws_arel_t[:latitude_minutes].eq( info[:latitude_minutes] ).and(
              ws_arel_t[:longitude_degrees].eq( info[:longitude_degrees] ).and(
                ws_arel_t[:longitude_minutes].eq( info[:longitude_minutes] )
              )
            )
          )
        ).or(
          Arel::Nodes::Grouping.new(
            ws_arel_t[:latitude_degrees_snow].eq( info[:latitude_degrees] ).and(
              ws_arel_t[:latitude_minutes_snow].eq( info[:latitude_minutes] ).and(
                ws_arel_t[:longitude_degrees_snow].eq( info[:longitude_degrees] ).and(
                  ws_arel_t[:longitude_minutes_snow].eq( info[:longitude_minutes] )
                )
              )
            )
          )
        )
      )

      visited_stations = Set.new
      WeatherStation.where( where_str ).each do |ws|
        ws.observation_location_id = observation_location.id
        ws.save!
        next if visited_stations.include?( ws.station_number )
        designate_same_region_to_old_observatory( ws.station_number, observation_location.id )
        visited_stations.add( ws.station_number )
      end
      WeatherStation.where( station_number: visited_stations, observation_location_id: nil ).each do |ws|
        ws.observation_location_id = observation_location.id
        ws.save!
      end
    end
  end

  def self.extract_location_data( inner_div )
    title, stid, stname, kansoku = nil

    title = inner_div.attribute( 'title' ).value
    inner_div.search( 'input' ).each do |input_tag|
      case input_tag.attribute( 'name' ).value
      when 'stid'
        stid = input_tag.attribute( 'value' ).value.strip
      when 'stname'
        stname = input_tag.attribute( 'value' ).value.strip
      when 'kansoku'
        ## この値自体は0かどうかしか見ないので詳細のチェック等は不要
        ## https://www.data.jma.go.jp/risk/obsdl/top/help1.html#chiten_select
        kansoku = input_tag.attribute( 'value' ).value.strip
      end
    end

    [title, stid, stname, kansoku]
  end

  def self.designate_same_region_to_old_observatory( station_number, observation_location_id )
    queue = [station_number]
    old_station_numbers = []

    while queue.present?
      current_station_number = queue.shift

      same_region_stations = WeatherStation.where( station_number: current_station_number )
          .where.not( old_station_number: current_station_number ).pluck( :old_station_number )
      old_station_numbers.concat( same_region_stations )
      queue.concat( same_region_stations )
    end

    old_station_numbers.uniq!
    WeatherStation.where( station_number: old_station_numbers ).each do |ws|
      ws.observation_location_id = observation_location_id
      ws.save!
    end
  end

  def self.extract_location_info( text )
    name, kana, latitude_degrees, latitude_minutes, longitude_degrees, longitude_minutes, elevation, note = nil

    text.split( "\n" ).each do |pos_info|
      pos_info_buf = pos_info.split( /[:：]/ )
      if 2 == pos_info_buf.length
        case pos_info_buf[0]
        when '地点名'
          name = pos_info_buf[1]
        when 'カナ'
          kana = pos_info_buf[1]
        when '北緯'
          m = /(\d+)度(\d+(\.\d+)?)分/.match( pos_info_buf[1] )
          if m
            latitude_degrees = m[1].to_i
            latitude_minutes = m[2].to_f
          end
        when '東経'
          m = /(\d+)度(\d+(\.\d+)?)分/.match( pos_info_buf[1] )
          if m
            longitude_degrees = m[1].to_i
            longitude_minutes = m[2].to_f
          end
        when '南緯'
          m = /(\d+)度(\d+(\.\d+)?)分/.match( pos_info_buf[1] )
          if m
            latitude_degrees = -1 * m[1].to_i
            latitude_minutes = m[2].to_f
          end
        when '標高'
          m = /(\d+(\.\d+)?)m/.match( pos_info_buf[1] )
          if m
            elevation = m[1]
          end
        end
      else
        unless name.nil?
          note = note.nil? ? pos_info : note + ' ' + pos_info
        end
      end
    end

    return {
      name: name,
      kana: kana,
      latitude_degrees: latitude_degrees,
      latitude_minutes: latitude_minutes,
      longitude_degrees: longitude_degrees, 
      longitude_minutes: longitude_minutes,
      elevation: elevation,
      note: note
    }
  end
end
