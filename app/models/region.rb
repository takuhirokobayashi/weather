class Region < ApplicationRecord
  has_many :region_observation_locations, dependent: :destroy
  has_many :observation_locations, through: :region_observation_locations

  validates :prid, presence: true, uniqueness: true
  validates :name, presence: true

  def self.get_list
    uri = URI( Constants::JAPAN_METEOROLOGICAL_AGENCY )
    http = Net::HTTP.new( uri.host, uri.port )
    http.use_ssl = true

    params = URI.encode_www_form( pd: '00' )
    logger.info "Request POST #{Constants::JMA_SITE_TOP_STATION}"
    response = http.request_post( Constants::JMA_SITE_TOP_STATION, params )

    handle_response( response )
  end

  private

  def self.handle_response( response )
    unless '200' == response.code
      raise JmaHttpResponseError.new(
        I18n.t( 'errors.messages.get_region_error', response_code: response.code )
      )
    end

    doc = Nokogiri::HTML.parse( Constants::HTML_DUMMY_HEADER + response.body + Constants::HTML_DUMMY_FOOTER )

    process_regions( doc )
  end

  def self.process_regions( doc )
    doc.search( 'body td' ).each do |td|
      region_name = td.text.strip
      next if region_name.empty?

      input = td.at( 'input[name="prid"]' )
      next unless input

      region_prid = input['value'].strip
      update_or_create_region( region_prid, region_name )
    end
  end

  def self.update_or_create_region( region_prid, region_name )
    region = Region.find_or_initialize_by( prid: region_prid )
    region.update!( name: region_name )
  end
end
