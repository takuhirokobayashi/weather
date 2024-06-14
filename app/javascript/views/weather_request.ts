import { parse, isBefore, addHours, addDays, isEqual, parseISO, } from "date-fns"
import { BigNumber } from 'bignumber.js'

export interface WeatherRequestModel {
  weather_request_id: number,
  wr_observation_date_time: Date,
  status: string,
  measurement_id: null | number,
  temperature: null | number,
  temperature_quality_information: null | number,
  temperature_homogeneity_number: null | number,
  precipitation: null | number,
  precipitation_no_phenomena_information: null | boolean,
  precipitation_quality_information: null | number,
  precipitation_homogeneity_number: null | number,
  snowfall: null | number,
  snowfall_no_phenomena_information: null | boolean,
  snowfall_quality_information: null | number,
  snowfall_homogeneity_number: null | number,
  snow_depth: null | number,
  snow_depth_no_phenomena_information: null | boolean,
  snow_depth_quality_information: null | number,
  snow_depth_homogeneity_number: null | number,
  sunshine_duration: null | number,
  sunshine_duration_no_phenomena_information: null | boolean,
  sunshine_duration_quality_information: null | number,
  sunshine_duration_homogeneity_number: null | number,
  wind_speed: null | number,
  wind_speed_quality_information: null | number,
  compass_direction: null | string,
  wind_direction_quality_information: null | number,
  wind_direction_homogeneity_number: null | number,
  solar_radiation: null | number,
  solar_radiation_quality_information: null | number,
  solar_radiation_homogeneity_number: null | number,
  local_atmospheric_pressure: null | number,
  local_atmospheric_pressure_quality_information: null | number,
  local_atmospheric_pressure_homogeneity_number: null | number,
  sea_atmospheric_pressure: null | number,
  sea_atmospheric_pressure_quality_information: null | number,
  sea_atmospheric_pressure_homogeneity_number: null | number,
  relative_humidity: null | number,
  relative_humidity_quality_information: null | number,
  relative_humidity_homogeneity_number: null | number,
  vapor_pressure: null | number,
  vapor_pressure_quality_information: null | number,
  vapor_pressure_homogeneity_number: null | number,
  dew_point_temperature: null | number,
  dew_point_temperature_quality_information: null | number,
  dew_point_temperature_homogeneity_number: null | number,
  weather_symbol: null | string,
  weather: null | string,
  weather_quality_information: null | number,
  weather_homogeneity_number: null | number,
  cloud_cover: null | number,
  cloud_cover_quality_information: null | number,
  cloud_cover_homogeneity_number: null | number,
  visibility: null | number,
  visibility_quality_information: null | number,
  visibility_homogeneity_number: null | number
}

class WeatherRequest {
  public fetchWeatherRequests = (
    observationLocationId: string,
    startDate: string,
    endDate: string,
    state: Array<WeatherRequestModel>,
    setFunction: ( val: Array<WeatherRequestModel> ) => void,
  ) => {
    let startDateDt: Date = new Date()
    let endDateDt: Date = new Date()
    try {
      startDateDt = parse( startDate, 'yyyy-MM-dd', new Date() )
      endDateDt = parse( endDate, 'yyyy-MM-dd', new Date() )
    } catch( ex ) {
      return
    }
    const query = new URLSearchParams( {
      observation_location_id: observationLocationId,
      start_date: startDate,
      end_date: endDate,
    } )
    fetch( `/weather_requests?${query}`, {
      method: 'GET',
    } )
    .then( ( response: Response, ) => {
      if ( response.ok && 'No Content' !== response.statusText ) {
        return response.json()
      }

      return Promise.reject( new Error( `response ok = ${response.ok} status = ${response.status}` ) )
    } )
    .then( ( data, ) => {
      setFunction( this.mergeWeatherRequests( startDateDt, endDateDt, state, data ) )
    } )
    .catch( ( error ) => {
      console.error( 'ERROR FETCHING weather request:', error )
    } )
  }

  public mergeWeatherRequests = (
    startDateDt: Date,
    endDateDt: Date,
    state: Array<WeatherRequestModel>,
    data: any,
  ): Array<WeatherRequestModel> => {
    if ( ! Array.isArray( data ) ) {
      throw new Error( 'data NOT ARRAY' )
    }

    let weather_requests_buffer: Array<WeatherRequestModel> = []
    if ( 0 == state.length ) {
      let currentDate = startDateDt
      while ( isBefore( currentDate, addDays( endDateDt, 1 ) ) ) {
        currentDate = addHours( currentDate, 1 )
        weather_requests_buffer.push(
          {
            weather_request_id: 0,
            wr_observation_date_time: currentDate,
            status: '',
            measurement_id: null,
            temperature: null,
            temperature_quality_information: null,
            temperature_homogeneity_number: null,
            precipitation: null,
            precipitation_no_phenomena_information: null,
            precipitation_quality_information: null,
            precipitation_homogeneity_number: null,
            snowfall: null,
            snowfall_no_phenomena_information: null,
            snowfall_quality_information: null,
            snowfall_homogeneity_number: null,
            snow_depth: null,
            snow_depth_no_phenomena_information: null,
            snow_depth_quality_information: null,
            snow_depth_homogeneity_number: null,
            sunshine_duration: null,
            sunshine_duration_no_phenomena_information: null,
            sunshine_duration_quality_information: null,
            sunshine_duration_homogeneity_number: null,
            wind_speed: null,
            wind_speed_quality_information: null,
            compass_direction: null,
            wind_direction_quality_information: null,
            wind_direction_homogeneity_number: null,
            solar_radiation: null,
            solar_radiation_quality_information: null,
            solar_radiation_homogeneity_number: null,
            local_atmospheric_pressure: null,
            local_atmospheric_pressure_quality_information: null,
            local_atmospheric_pressure_homogeneity_number: null,
            sea_atmospheric_pressure: null,
            sea_atmospheric_pressure_quality_information: null,
            sea_atmospheric_pressure_homogeneity_number: null,
            relative_humidity: null,
            relative_humidity_quality_information: null,
            relative_humidity_homogeneity_number: null,
            vapor_pressure: null,
            vapor_pressure_quality_information: null,
            vapor_pressure_homogeneity_number: null,
            dew_point_temperature: null,
            dew_point_temperature_quality_information: null,
            dew_point_temperature_homogeneity_number: null,
            weather_symbol: null,
            weather: null,
            weather_quality_information: null,
            weather_homogeneity_number: null,
            cloud_cover: null,
            cloud_cover_quality_information: null,
            cloud_cover_homogeneity_number: null,
            visibility: null,
            visibility_quality_information: null,
            visibility_homogeneity_number: null
          }
        )
      }
    } else {
      weather_requests_buffer = [...state]
    }
    for ( const row of data ) {
      let checkedModel: boolean | WeatherRequestModel = this.isWeatherRequestModel( row )
      if ( typeof checkedModel !== 'boolean' && false !== checkedModel ) {
        weather_requests_buffer = weather_requests_buffer.map(
          ( val: WeatherRequestModel, ) => (
            (
              isEqual( val.wr_observation_date_time, row.wr_observation_date_time )
            ) ?
            row : val
          )
        )
      } else {
        throw new Error( 'WRONG DATA FORMAT WeatherRequestModel' )
      }
    }

    return weather_requests_buffer
  }

  private isWeatherRequestModel = ( arg: any ): arg is WeatherRequestModel | boolean => {
    if (
      ( ! arg ) ||
      typeof arg.weather_request_id !== 'number' ||
      typeof arg.wr_observation_date_time !== 'string' ||
      typeof arg.status !== 'string' ||
      ( null !== arg.measurement_id && typeof arg.measurement_id !== 'number' ) ||
      ( null !== arg.temperature && typeof arg.temperature !== 'string' ) ||
      ( null !== arg.temperature_quality_information && typeof arg.temperature_quality_information !== 'number' ) ||
      ( null !== arg.temperature_homogeneity_number && typeof arg.temperature_homogeneity_number !== 'number' ) ||
      ( null !== arg.precipitation && typeof arg.precipitation !== 'string' ) ||
      ( null !== arg.precipitation_no_phenomena_information && typeof arg.precipitation_no_phenomena_information !== 'boolean' ) ||
      ( null !== arg.precipitation_quality_information && typeof arg.precipitation_quality_information !== 'number' ) ||
      ( null !== arg.precipitation_homogeneity_number && typeof arg.precipitation_homogeneity_number !== 'number' ) ||
      ( null !== arg.snowfall && typeof arg.snowfall !== 'number' ) ||
      ( null !== arg.snowfall_no_phenomena_information && typeof arg.snowfall_no_phenomena_information !== 'boolean' ) ||
      ( null !== arg.snowfall_quality_information && typeof arg.snowfall_quality_information !== 'number' ) ||
      ( null !== arg.snowfall_homogeneity_number && typeof arg.snowfall_homogeneity_number !== 'number' ) ||
      ( null !== arg.snow_depth && typeof arg.snow_depth !== 'number' ) ||
      ( null !== arg.snow_depth_no_phenomena_information && typeof arg.snow_depth_no_phenomena_information !== 'boolean' ) ||
      ( null !== arg.snow_depth_quality_information && typeof arg.snow_depth_quality_information !== 'number' ) ||
      ( null !== arg.snow_depth_homogeneity_number && typeof arg.snow_depth_homogeneity_number !== 'number' ) ||
      ( null !== arg.sunshine_duration && typeof arg.sunshine_duration !== 'string' ) ||
      ( null !== arg.sunshine_duration_no_phenomena_information && typeof arg.sunshine_duration_no_phenomena_information !== 'boolean' ) ||
      ( null !== arg.sunshine_duration_quality_information && typeof arg.sunshine_duration_quality_information !== 'number' ) ||
      ( null !== arg.sunshine_duration_homogeneity_number && typeof arg.sunshine_duration_homogeneity_number !== 'number' ) ||
      ( null !== arg.wind_speed && typeof arg.wind_speed !== 'string' ) ||
      ( null !== arg.wind_speed_quality_information && typeof arg.wind_speed_quality_information !== 'number' ) ||
      ( null !== arg.compass_direction && typeof arg.compass_direction !== 'string' ) ||
      ( null !== arg.wind_direction_quality_information && typeof arg.wind_direction_quality_information !== 'number' ) ||
      ( null !== arg.wind_direction_homogeneity_number && typeof arg.wind_direction_homogeneity_number !== 'number' ) ||
      ( null !== arg.solar_radiation && typeof arg.solar_radiation !== 'number' ) ||
      ( null !== arg.solar_radiation_quality_information && typeof arg.solar_radiation_quality_information !== 'number' ) ||
      ( null !== arg.solar_radiation_homogeneity_number && typeof arg.solar_radiation_homogeneity_number !== 'number' ) ||
      ( null !== arg.local_atmospheric_pressure && typeof arg.local_atmospheric_pressure !== 'string' ) ||
      ( null !== arg.local_atmospheric_pressure_quality_information && typeof arg.local_atmospheric_pressure_quality_information !== 'number' ) ||
      ( null !== arg.local_atmospheric_pressure_homogeneity_number && typeof arg.local_atmospheric_pressure_homogeneity_number !== 'number' ) ||
      ( null !== arg.sea_atmospheric_pressure && typeof arg.sea_atmospheric_pressure !== 'string' ) ||
      ( null !== arg.sea_atmospheric_pressure_quality_information && typeof arg.sea_atmospheric_pressure_quality_information !== 'number' ) ||
      ( null !== arg.sea_atmospheric_pressure_homogeneity_number && typeof arg.sea_atmospheric_pressure_homogeneity_number !== 'number' ) ||
      ( null !== arg.relative_humidity && typeof arg.relative_humidity !== 'number' ) ||
      ( null !== arg.relative_humidity_quality_information && typeof arg.relative_humidity_quality_information !== 'number' ) ||
      ( null !== arg.relative_humidity_homogeneity_number && typeof arg.relative_humidity_homogeneity_number !== 'number' ) ||
      ( null !== arg.vapor_pressure && typeof arg.vapor_pressure !== 'string' ) ||
      ( null !== arg.vapor_pressure_quality_information && typeof arg.vapor_pressure_quality_information !== 'number' ) ||
      ( null !== arg.vapor_pressure_homogeneity_number && typeof arg.vapor_pressure_homogeneity_number !== 'number' ) ||
      ( null !== arg.dew_point_temperature && typeof arg.dew_point_temperature !== 'string' ) ||
      ( null !== arg.dew_point_temperature_quality_information && typeof arg.dew_point_temperature_quality_information !== 'number' ) ||
      ( null !== arg.dew_point_temperature_homogeneity_number && typeof arg.dew_point_temperature_homogeneity_number !== 'number' ) ||
      ( null !== arg.weather_symbol && typeof arg.weather_symbol !== 'string' ) ||
      ( null !== arg.weather && typeof arg.weather !== 'string' ) ||
      ( null !== arg.weather_quality_information && typeof arg.weather_quality_information !== 'number' ) ||
      ( null !== arg.weather_homogeneity_number && typeof arg.weather_homogeneity_number !== 'number' ) ||
      ( null !== arg.cloud_cover && typeof arg.cloud_cover !== 'number' ) ||
      ( null !== arg.cloud_cover_quality_information && typeof arg.cloud_cover_quality_information !== 'number' ) ||
      ( null !== arg.cloud_cover_homogeneity_number && typeof arg.cloud_cover_homogeneity_number !== 'number' ) ||
      ( null !== arg.visibility && typeof arg.visibility !== 'string' ) ||
      ( null !== arg.visibility_quality_information && typeof arg.visibility_quality_information !== 'number' ) ||
      ( null !== arg.visibility_homogeneity_number && typeof arg.visibility_homogeneity_number !== 'number' )
    ) {
      return false
    }

    let wr_observation_date_time: boolean | Date = this.check_json_time( arg.wr_observation_date_time )
    if ( typeof wr_observation_date_time === 'boolean' ) {
      return false
    }
    arg.wr_observation_date_time = wr_observation_date_time

    let temperature: boolean | number = this.check_json_decimal_to_number( arg.temperature )
    if ( typeof temperature === 'boolean' && ! temperature ) {
      return false
    }
    arg.temperature = temperature

    let precipitation: boolean | number = this.check_json_decimal_to_number( arg.precipitation )
    if ( typeof precipitation === 'boolean' && ! precipitation ) {
      return false
    }
    arg.precipitation = precipitation

    let sunshine_duration: boolean | number = this.check_json_decimal_to_number( arg.sunshine_duration )
    if ( typeof sunshine_duration === 'boolean' && ! sunshine_duration ) {
      return false
    }
    arg.sunshine_duration = sunshine_duration

    let wind_speed: boolean | number = this.check_json_decimal_to_number( arg.wind_speed )
    if ( typeof wind_speed === 'boolean' && ! wind_speed ) {
      return false
    }
    arg.wind_speed = wind_speed

    let local_atmospheric_pressure: boolean | number = this.check_json_decimal_to_number( arg.local_atmospheric_pressure )
    if ( typeof local_atmospheric_pressure === 'boolean' && ! local_atmospheric_pressure ) {
      return false
    }
    arg.local_atmospheric_pressure = local_atmospheric_pressure

    let sea_atmospheric_pressure: boolean | number = this.check_json_decimal_to_number( arg.sea_atmospheric_pressure )
    if ( typeof sea_atmospheric_pressure === 'boolean' && ! sea_atmospheric_pressure ) {
      return false
    }
    arg.sea_atmospheric_pressure = sea_atmospheric_pressure

    let vapor_pressure: boolean | number = this.check_json_decimal_to_number( arg.vapor_pressure )
    if ( typeof vapor_pressure === 'boolean' && ! vapor_pressure ) {
      return false
    }
    arg.vapor_pressure = vapor_pressure

    let dew_point_temperature: boolean | number = this.check_json_decimal_to_number( arg.dew_point_temperature )
    if ( typeof dew_point_temperature === 'boolean' && ! dew_point_temperature ) {
      return false
    }
    arg.dew_point_temperature = dew_point_temperature

    let visibility: boolean | number = this.check_json_decimal_to_number( arg.visibility )
    if ( typeof visibility === 'boolean' && ! visibility ) {
      return false
    }
    arg.visibility = visibility

    return arg
  }

  private check_json_time = ( arg: any ): arg is Date | boolean => {
    if ( null === arg ) {
      return true
    }
    if ( typeof arg !== 'string' ) {
      return false
    }

    let dateBuffer: Date
    try {
      if ( arg.includes( 'T' ) ) {
        dateBuffer = parseISO( arg )
      } else {
        dateBuffer = parse( arg, 'yyyy-MM-dd HH:mm:ss', new Date() )
      }
    } catch( ex ) {
      return false
    }

    arg = dateBuffer
    return arg
  }

  public check_json_decimal_to_number = ( arg: any ): arg is number => {
    if ( null === arg ) {
      return true
    }
    if ( typeof arg !== 'string' ) {
      return false
    }

    let bigNumberbuffer: BigNumber = new BigNumber( 0 )
    try {
      bigNumberbuffer = new BigNumber( arg )
      arg = bigNumberbuffer.toNumber()
    } catch( ex ) {
      return false
    }

    return arg
  }
}

export default WeatherRequest
