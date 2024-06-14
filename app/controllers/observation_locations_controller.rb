class ObservationLocationsController < ApplicationController
  def index
    @observation_locations = Region.find( params[:region_id] ).observation_locations.order( :stid )

    render json: @observation_locations
  end
end
