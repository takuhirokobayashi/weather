class RegionsController < ApplicationController
  def index
    @regions = Region.all

    render json: @regions.order( :prid )
  end
end
