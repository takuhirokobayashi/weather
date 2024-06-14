import React from 'react'
import { createRoot } from 'react-dom/client'

import WeatherRequestTable from './weather_request_table'

declare global {
  var weatherRequest: (divTagId: string) => void
}

globalThis.weatherRequest = ( divTagId: string, ) => {
  const container = document.getElementById( divTagId )
  if ( container ) {
    const root = createRoot( container )
    root.render(
      React.createElement( WeatherRequestTable )
    )
  }
}
