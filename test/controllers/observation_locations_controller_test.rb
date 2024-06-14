require "test_helper"

class RegionstsControllerTest < ActionDispatch::IntegrationTest
  fixtures :regions, :observation_locations, :region_observation_locations

  setup do
    @region = regions( :negi )
    @observation_location = observation_locations( :negibozu )
  end

  test "観測地点一覧取得" do
    get region_observation_locations_url( @region.id ), as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal Region.find( @region.id ).observation_locations.count, json_response.length
    assert_equal @observation_location.stname, json_response.first['stname']
  end
end
