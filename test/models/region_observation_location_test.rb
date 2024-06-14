require "test_helper"

class RegionObservationLocationTest < ActiveSupport::TestCase
  fixtures :regions, :observation_locations

  def setup
    @region = regions( :aomorii )
    @observation_location = observation_locations( :negibozu )
  end

  test 'Regionが空だとエラー' do
    rol = RegionObservationLocation.new( observation_location_id: @observation_location.id )
    assert_not rol.valid?, 'RegionObservationLocationはregion_idを指定せずvalid?された'
    assert_not_nil rol.errors[:region_id]
  end

  test 'ObservationLocationが空だとエラー' do
    rol = RegionObservationLocation.new( region_id: @region.id )
    assert_not rol.valid?, 'RegionObservationLocationはobservation_location_idを指定せずvalid?された'
    assert_not_nil rol.errors[:observation_location_id]
  end

  test '正常値を設定してvalid?に成功した' do
    rol = RegionObservationLocation.new( region_id: @region.id, observation_location_id: @observation_location.id )
    assert rol.valid?
  end

  test '登録値が重複しているとエラー' do
    rol = RegionObservationLocation.new( region_id: @region.id, observation_location_id: @observation_location.id )
    rol.save!
    rol_next = RegionObservationLocation.new( region_id: @region.id, observation_location_id: @observation_location.id )
    assert_not rol_next.valid?, 'RegionObservationLocationは登録値が重複しているデータを指定されvalid?された'
    assert_not_nil rol_next.errors[:region_id]
  end
end
