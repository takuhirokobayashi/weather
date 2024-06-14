export interface ObservationLocationModel {
  id: number,
  stid: string,
  stname: string,
}

class ObservationLocation {
  public listedObservationLocation = (
    regionId: string,
    setObservationLocationList: ( val: Array<ObservationLocationModel>, ) => void,
  ) => {
    if ( ! regionId || ! /^\d+$/.test( regionId ) ) {
      return
    }

    fetch( `/regions/${regionId}/observation_locations`, {
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
        return Promise.reject( new Error( 'WRONG DATA FORMAT ObservationLocationModel' ) )
      }

      let ObservationLocationListBuffer: Array<ObservationLocationModel> = []
      for ( const row of data ) {
        if ( this.isObservationLocationModel( row ) ) {
          ObservationLocationListBuffer.push( row )
        } else {
          return Promise.reject( new Error( 'WRONG DATA FORMAT ObservationLocationModel' ) )
        }
      }

      setObservationLocationList( ObservationLocationListBuffer )
    } )
    .catch( ( error ) => {
      console.error( 'ERROR FETCHING observation locations:', error )
    } )
  }

  private isObservationLocationModel = ( arg: any ): arg is ObservationLocationModel => {
    return (
      arg &&
      typeof arg.id === 'number' &&
      typeof arg.stid === 'string' &&
      typeof arg.stname === 'string'
    )
  }
}

export default ObservationLocation
