class WeatherRequest < ApplicationRecord
  belongs_to :observation_location
  belongs_to :measurement, optional: true

  validates :observation_date_time, presence: true
  validates :status, presence: true, inclusion: { in: -> { WeatherRequest.statuses } }
  validates :request_time, presence: true
  validates :retry_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  STATUS_INITIAL = 'initial'
  STATUS_CANCELLED = 'cancelled'
  STATUS_RETRY = 'retry'
  STATUS_ERROR = 'error'
  STATUS_SUCCESS = 'success'
  STATUS_NONE_RECORD = 'none_record'

  scope :initial, -> { where( status: STATUS_INITIAL ) }
  scope :cancelled, -> { where( status: STATUS_CANCELLED ) }
  scope :retrying, -> { where( status: STATUS_RETRY ) }
  scope :errored, -> { where( status: STATUS_ERROR ) }
  scope :successful, -> { where( status: STATUS_SUCCESS ) }
  scope :none_record, -> { where( status: STATUS_NONE_RECORD ) }

  def self.statuses
    [STATUS_INITIAL, STATUS_CANCELLED, STATUS_RETRY, STATUS_ERROR, STATUS_SUCCESS, STATUS_NONE_RECORD]
  end

  def self.retry_cancelled_requests
    cancelled.find_each do |request|
      request.update( status: STATUS_RETRY )
    end
  end

  def self.cancel_requests
    where( status: [STATUS_INITIAL, STATUS_RETRY] ).update_all( status: STATUS_CANCELLED )
  end

  def set_error( error_message )
    update( status: STATUS_ERROR, error_message: error_message ) if STATUS_ERROR != status
  end

  def set_successful( measurement_id, success_time )
    update( measurement_id: measurement_id, success_time: success_time, status: STATUS_SUCCESS )
  end

  def self.none_queueing?
    ActiveRecord::Base.uncached do
      where( status: [STATUS_INITIAL, STATUS_RETRY] ).none?
    end
  end

  def set_initial
    self.status = STATUS_INITIAL
  end

  def set_retry
    self.status = STATUS_RETRY
  end

  def set_cancell
    self.status = STATUS_CANCELLED
  end

  def set_none_record
    self.status = STATUS_NONE_RECORD
  end

  def cancelled?
    STATUS_CANCELLED == self.status
  end

  def finished?
    STATUS_ERROR == self.status || STATUS_SUCCESS == self.status || STATUS_NONE_RECORD == self.status
  end

  def self.list_select_joins
    wr_arel_t = WeatherRequest.arel_table
    m_arel_t = Measurement.arel_table
    wd_arel_t = WindDirection.arel_table
    ws_arel_t = WeatherSymbol.arel_table
    m_join_conds = wr_arel_t.join( m_arel_t, Arel::Nodes::OuterJoin ).on(
      m_arel_t[:id].eq( wr_arel_t[:measurement_id] )
    ).join_sources
    wd_join_conds = m_arel_t.join( wd_arel_t ).on(
      wd_arel_t[:id].eq( m_arel_t[:wind_direction_id] )
    ).join_sources
    ws_join_conds = m_arel_t.join( ws_arel_t ).on(
      ws_arel_t[:id].eq( m_arel_t[:weather_symbol_id] )
    ).join_sources

    joins( m_join_conds, wd_join_conds, ws_join_conds )
    .select(
      wr_arel_t[:id].as( 'weather_request_id' ),
      wr_arel_t[:observation_date_time].as( 'wr_observation_date_time' ),
      wr_arel_t[:status],
      wr_arel_t[:measurement_id],
      m_arel_t[:temperature],
      m_arel_t[:temperature_quality_information],
      m_arel_t[:temperature_homogeneity_number],
      m_arel_t[:precipitation],
      m_arel_t[:precipitation_no_phenomena_information],
      m_arel_t[:precipitation_quality_information],
      m_arel_t[:precipitation_homogeneity_number],
      m_arel_t[:snowfall],
      m_arel_t[:snowfall_no_phenomena_information],
      m_arel_t[:snowfall_quality_information],
      m_arel_t[:snowfall_homogeneity_number],
      m_arel_t[:snow_depth],
      m_arel_t[:snow_depth_no_phenomena_information],
      m_arel_t[:snow_depth_quality_information],
      m_arel_t[:snow_depth_homogeneity_number],
      m_arel_t[:sunshine_duration],
      m_arel_t[:sunshine_duration_no_phenomena_information],
      m_arel_t[:sunshine_duration_quality_information],
      m_arel_t[:sunshine_duration_homogeneity_number],
      m_arel_t[:wind_speed],
      m_arel_t[:wind_speed_quality_information],
      wd_arel_t[:compass_direction],
      m_arel_t[:wind_direction_quality_information],
      m_arel_t[:wind_direction_homogeneity_number],
      m_arel_t[:solar_radiation],
      m_arel_t[:solar_radiation_quality_information],
      m_arel_t[:solar_radiation_homogeneity_number],
      m_arel_t[:local_atmospheric_pressure],
      m_arel_t[:local_atmospheric_pressure_quality_information],
      m_arel_t[:local_atmospheric_pressure_homogeneity_number],
      m_arel_t[:sea_atmospheric_pressure],
      m_arel_t[:sea_atmospheric_pressure_quality_information],
      m_arel_t[:sea_atmospheric_pressure_homogeneity_number],
      m_arel_t[:relative_humidity],
      m_arel_t[:relative_humidity_quality_information],
      m_arel_t[:relative_humidity_homogeneity_number],
      m_arel_t[:vapor_pressure],
      m_arel_t[:vapor_pressure_quality_information],
      m_arel_t[:vapor_pressure_homogeneity_number],
      m_arel_t[:dew_point_temperature],
      m_arel_t[:dew_point_temperature_quality_information],
      m_arel_t[:dew_point_temperature_homogeneity_number],
      ws_arel_t[:weather_symbol],
      ws_arel_t[:weather],
      m_arel_t[:weather_quality_information],
      m_arel_t[:weather_homogeneity_number],
      m_arel_t[:cloud_cover],
      m_arel_t[:cloud_cover_quality_information],
      m_arel_t[:cloud_cover_homogeneity_number],
      m_arel_t[:visibility],
      m_arel_t[:visibility_quality_information],
      m_arel_t[:visibility_homogeneity_number]
    )
  end
end
