import { Subscription, createConsumer } from '@rails/actioncable'
import { useState, useEffect, type ChangeEvent, } from 'react'
import { parse, format, } from "date-fns"

import ObservationLocation, { type ObservationLocationModel } from './observation_location'
import WeatherRequest from "./weather_request"
import type { WeatherRequestModel } from "./weather_request"
import {
  Container, FormContainer, Input, Select, Button,
  TableContainer, Table, TableHeader, TableCell, TableRow, LoadingBar,
} from './styles'

interface RegionModel {
  id: number,
  name: string,
}

export default function WeatherRequestTable() {
  const observation_location = new ObservationLocation
  const weather_request = new WeatherRequest
  const cable = createConsumer()
  let subscription: Subscription

  const [startDate, setStartDate] = useState<string>( '' )
  const [endDate, setEndDate] = useState<string>( '' )
  const [regionList, setRegionList] = useState<Array<RegionModel>>( [] )
  const [observationLocationList, setObservationLocationList] = useState<Array<ObservationLocationModel>>( [] )
  const [regionId, setRegionId] = useState<string>( '' )
  const [observationLocationId, setObservationLocationId] = useState<string>( '' )
  const [weatherRequestRecords, setWeatherRequestRecords] = useState<Array<WeatherRequestModel>>( [] )

  useEffect(
    () => {
      fetch( '/regions', {
        method: 'GET',
      } )
      .then( ( response: Response, ) => {
        if ( response.ok && 'No Content' !== response.statusText ) {
          return response.json()
        }
  
        return Promise.reject( new Error( `response ok = ${response.ok} status = ${response.status}` ) )
      } )
      .then( ( data, ) => {
        if ( ! Array.isArray( data ) ) {
          return Promise.reject( new Error( 'WRONG DATA FORMAT Region' ) )
        }
  
        let RegionListBuffer: Array<RegionModel> = []
        for ( const row of data ) {
          RegionListBuffer.push( row )
        }
  
        setRegionList( RegionListBuffer )
      } )
      .catch( ( error ) => {
        console.error( 'ERROR FETCHING observation locations:', error )
      } )

      return () => {
        setRegionList( [] )
      }
    }, []
  )


  useEffect(
    () => {
      if ( '' == observationLocationId ) {
        if ( subscription ) {
          subscription.unsubscribe()
        }
        return
      }

      subscription = cable.subscriptions.create(
        { channel: 'WeatherRequestChannel', observation_location_id: observationLocationId, },
        {
          received( data: any ) {
            let startDateDt: Date = new Date()
            let endDateDt: Date = new Date()
            try {
              startDateDt = parse( startDate, 'yyyy-MM-dd', new Date() )
              endDateDt = parse( endDate, 'yyyy-MM-dd', new Date() )
            } catch( ex ) {
              return
            }

            setWeatherRequestRecords( ( previousRecords ) =>
              weather_request.mergeWeatherRequests( startDateDt, endDateDt, previousRecords, data )
            )
          }
        }
      )

      return () => {
        if ( subscription ) {
          subscription.unsubscribe()
        }
      }
    }, [observationLocationId]
  )

  const onChangeRegion = ( evt: ChangeEvent<HTMLSelectElement> ) => {
    setWeatherRequestRecords( [] )
    setRegionId( evt.target.value )
    observation_location.listedObservationLocation( evt.target.value, setObservationLocationList )
  }

  const fetchWeatherRequests = () => {
    weather_request.fetchWeatherRequests( observationLocationId, startDate, endDate, weatherRequestRecords, setWeatherRequestRecords )
  }

  return(
    <Container>
      <FormContainer>
        <Input type = 'date' value = { startDate } onChange = { e => {
          setWeatherRequestRecords( [] )
          setStartDate( e.target.value )
        } } />
        <Input type = 'date' value = { endDate } onChange = { e => {
          setWeatherRequestRecords( [] )
          setEndDate( e.target.value )
        } } />
        <Select value = { regionId } onChange = { onChangeRegion }>
          <option value="" label=" "></option>
          { regionList.map(
            ( rec: RegionModel,) => (
              <option key = { rec.id } value = { rec.id }>{ rec.name }</option>
            )
          ) }
        </Select>
        <Select value = { observationLocationId } onChange = { e => {
          setWeatherRequestRecords( [] )
          setObservationLocationId( e.target.value )
        } }>
          <option value="" label=" "></option>
          { observationLocationList.map(
            ( rec: ObservationLocationModel,) => (
              <option key = { rec.id } value = { rec.id }>{ rec.stname }</option>
            )
          ) }
        </Select>
        <Button onClick = { fetchWeatherRequests }>
          { '送信' }
        </Button>
      </FormContainer>
      <TableContainer>
        <Table>
          <thead>
            <tr>
              <TableHeader>時間</TableHeader>
              <TableHeader>気温</TableHeader>
              <TableHeader>降水量</TableHeader>
              <TableHeader>降雪</TableHeader>
              <TableHeader>積雪</TableHeader>
              <TableHeader>日照時間</TableHeader>
              <TableHeader>風速</TableHeader>
              <TableHeader>風向</TableHeader>
              <TableHeader>日射量</TableHeader>
              <TableHeader>現地気圧</TableHeader>
              <TableHeader>海面気圧</TableHeader>
              <TableHeader>相対湿度</TableHeader>
              <TableHeader>蒸気圧</TableHeader>
              <TableHeader>露点温度</TableHeader>
              <TableHeader>天気</TableHeader>
              <TableHeader>雲量</TableHeader>
              <TableHeader>視程</TableHeader>
            </tr>
          </thead>
          <tbody>
            {
              weatherRequestRecords.map( ( val: WeatherRequestModel ) => (
                <TableRow key = { format( val.wr_observation_date_time, 'yyyyMMddHH' ) }>
                  <TableCell align = 'left'>{ format( val.wr_observation_date_time, 'yyyy/MM/dd HH時' ) }</TableCell>
                  {
                    ( 'error' == val.status || 'none_record' == val.status ) ? (
                      <TableCell colSpan = { 16 }>
                        { '観測所が無いためデータが存在しない、もしくはデータ形式に問題がある' }
                      </TableCell>
                    ) : (
                      null === val.measurement_id ? (
                        <TableCell colSpan = { 16 }>
                          <LoadingBar />
                        </TableCell>
                      ) : (
                        <>
                          <TableCell align = 'right'>{ null === val.temperature ? '' : val.temperature + ' ℃' }</TableCell>
                          <TableCell align = 'right'>{ null === val.precipitation ? '' : val.precipitation + ' mm' }</TableCell>
                          <TableCell align = 'right'>{ null === val.snowfall ? '' : val.snowfall + ' cm' }</TableCell>
                          <TableCell align = 'right'>{ null === val.snow_depth ? '' : val.snow_depth + ' cm' }</TableCell>
                          <TableCell align = 'right'>{ null === val.sunshine_duration ? '' : val.sunshine_duration + ' 時間' }</TableCell>
                          <TableCell align = 'right'>{ null === val.wind_speed ? '' : val.wind_speed + ' m/s' }</TableCell>
                          <TableCell>{ null === val.compass_direction ? '' : val.compass_direction }</TableCell>
                          <TableCell align = 'right'>{ null === val.solar_radiation ? '' : val.solar_radiation + ' MJ/㎡' }</TableCell>
                          <TableCell align = 'right'>{ null === val.local_atmospheric_pressure ? '' : val.local_atmospheric_pressure + ' hPa' }</TableCell>
                          <TableCell align = 'right'>{ null === val.sea_atmospheric_pressure ? '' : val.sea_atmospheric_pressure + ' hPa' }</TableCell>
                          <TableCell align = 'right'>{ null === val.relative_humidity ? '' : val.relative_humidity + ' ％' }</TableCell>
                          <TableCell align = 'right'>{ null === val.vapor_pressure ? '' : val.vapor_pressure + ' hPa' }</TableCell>
                          <TableCell align = 'right'>{ null === val.dew_point_temperature ? '' : val.dew_point_temperature + ' ℃' }</TableCell>
                          <TableCell>{ null === val.weather ? '' : val.weather }</TableCell>
                          <TableCell align = 'right'>{ null === val.cloud_cover ? '' : val.cloud_cover + ' 10分比' }</TableCell>
                          <TableCell align = 'right'>{ null === val.visibility ? '' : val.visibility + ' km' }</TableCell>
                        </>
                      )
                    )
                  }
                </TableRow>
              ) )
            }
          </tbody>
        </Table>
      </TableContainer>
    </Container>
  )
}
