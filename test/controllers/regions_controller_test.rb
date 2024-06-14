require "test_helper"

class RegionstsControllerTest < ActionDispatch::IntegrationTest
  fixtures :regions

  setup do
    @region = regions( :negi )
  end

  test "地域一覧取得" do
    get regions_url, as: :json
    assert_response :success
    json_response = JSON.parse( response.body )
    assert_equal Region.count, json_response.length
    assert_equal @region.name, json_response.first['name']
  end
end
