require "test_helper"

class MeasurementsControllerTest < ActionDispatch::IntegrationTest
  test "観測情報一覧取得" do
    get measurements_url
    assert_response :success
  end

  test "トップ画面取得" do
    get root_url
    assert_response :success
  end
end
