require "test_helper"
require 'webmock/minitest'

require_relative '../../app/models/jma_http_response_error'

class ObservationLocationTest < ActiveSupport::TestCase
  def setup
    # fixtureでは駄目なので…
    WeatherRequest.destroy_all
    Measurement.destroy_all
    WeatherStation.destroy_all
    ObservationLocation.destroy_all
    Region.destroy_all
    Region.create( prid: '31', name: 'あおもりぃ' )
  end

  test 'stidが空だとエラー' do
    ol = ObservationLocation.new( stname: 'どっか' )
    assert_not ol.valid?, 'ObservationLocationはstidを指定せずvalid?された'
    assert_not_nil ol.errors[:stid]
  end

  test 'stidが重複しているとエラー' do
    ol = ObservationLocation.new( stid: 'a1234', stname: 'どっか' )
    ol.save
    ol_next = ObservationLocation.new( stid: 'a1234', stname: 'かなた' )
    assert_not ol_next.valid?, 'ObservationLocationはstidが重複しているデータを指定されvalid?された'
    assert_not_nil ol_next.errors[:stid]
  end

  test 'stnameが空だとエラー' do
    ol = ObservationLocation.new( stid: 'a1234' )
    assert_not ol.valid?, 'ObservationLocationはstnameを指定せずvalid?された'
    assert_not_nil ol.errors[:stname]
  end

  test 'HTTPエラーが発生した' do
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 500, body: '' )
    assert_raises( JmaHttpResponseError ) do
      ObservationLocation.get_list()
    end
  end

  test 'データが1件も無かった' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_none.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 0, ObservationLocation.all.count()
    assert_equal 0, RegionObservationLocation.all.count()
  end

  test 'データを前半のみ読み込んだ' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_first_half.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
  end

  test 'データを後半のみ読み込んだ' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_latter_half.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
  end

  test 'データを1件読み込んだ' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_one.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
  end

  test '経度情報が欠損していて緯度が合致するAMEDAS地点情報が存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_no_latitude.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 0, ObservationLocation.all.count()
    assert_equal 0, RegionObservationLocation.all.count()
  end

  test '緯度情報が欠損していて経度が合致するAMEDAS地点情報が存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_no_longitude.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 0, ObservationLocation.all.count()
    assert_equal 0, RegionObservationLocation.all.count()
  end

  test '緯度・経度が合致するAMEDAS地点情報が存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_shojiyama.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_one.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
    assert_equal 1, WeatherStation.all.count()
    assert_equal ObservationLocation.all.first.id, WeatherStation.all.first.observation_location_id
  end

  test '緯度・経度が合致するAMEDAS地点情報と同一の観測所番号のレコードが存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_same_stnum.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_odanosawa.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
    assert_equal 6, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_equal ObservationLocation.all.first.id, ol_ids[0]
  end

  test '緯度・経度が合致するAMEDAS地点情報と同一の旧観測所番号のレコードが存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_same_old_stnum.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_aomori.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
    assert_equal 9, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_equal ObservationLocation.all.first.id, ol_ids[0]
  end

  test '緯度・経度が合致するAMEDAS地点情報と同一の観測所が存在しない' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_same_old_stnum.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_oowani.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
    assert_equal 9, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_nil ol_ids[0]
  end

  test '積雪側の緯度・経度が合致するAMEDAS地点情報が存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_same_snow_station_number_mod.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_ooma.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
    assert_equal 4, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_equal ObservationLocation.all.first.id, ol_ids[0]
  end

  test '積雪側の緯度・経度が合致するAMEDAS地点情報と同一の観測所番号のレコードが存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_same_snow_station_number_mod2.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_ooma.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
    assert_equal 4, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_equal ObservationLocation.all.first.id, ol_ids[0]
  end

  test '積雪側の緯度・経度が合致するAMEDAS地点情報と同一の旧観測所番号のレコードが存在する' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_same_snow_station_number_mod3.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_ooma.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 1, RegionObservationLocation.all.count()
    assert_equal 4, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_equal ObservationLocation.all.first.id, ol_ids[0]
  end

  test '現行の青森の地点情報を取り込み、場所が一致するAMEDAS地点情報なし' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_none_aomori.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_raw.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 37, ObservationLocation.all.count()
    assert_equal 37, RegionObservationLocation.all.count()
    assert_equal 7456, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_nil ol_ids[0]
  end

  test '現行の青森の地点情報を取り込み、場所が一致するAMEDAS地点情報あり' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_raw.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '31_aomori_raw.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .to_return( status: 200, body: response_tag )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 37, ObservationLocation.all.count()
    assert_equal 37, RegionObservationLocation.all.count()
    assert_equal 7650, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 38, ol_ids.length
    ol_ids.compact!
    assert_equal ObservationLocation.all.first.id, ol_ids[0]
  end

  test '静岡と山梨の地点情報を取り込み、同じ観測所あり' do
    # fixtureでは駄目なので…
    Region.destroy_all
    Region.create( prid: '50', name: 'しずおけ' )
    Region.create( prid: '49', name: 'なっしーやま' )
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'weather_station', 'amdmaster_fujisan.csv' ) )
    stub_request( :get, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_AME_MASTER )
    .to_return( status: 200, body: response_tag )
    WeatherStation.get_list()
    response_tag_sizuoka = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '50_sizuoka_fujisan.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .with( body: 'pd=50' )
    .to_return( status: 200, body: response_tag_sizuoka )
    response_tag_yamanasi = File.read( Rails.root.join( 'test', 'response_data', 'observation_location', '49_yamanasi_fujisan.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_REGION_STATION )
    .with( body: 'pd=49' )
    .to_return( status: 200, body: response_tag_yamanasi )
    assert_nothing_raised do
      ObservationLocation.get_list()
    end
    assert_equal 1, ObservationLocation.all.count()
    assert_equal 2, RegionObservationLocation.all.count()
    assert_equal 2, WeatherStation.all.count()
    ol_ids = WeatherStation.all.pluck( :observation_location_id )
    ol_ids = ol_ids.uniq
    assert_equal 1, ol_ids.length
    assert_equal ObservationLocation.all.first.id, ol_ids[0]
  end
end
