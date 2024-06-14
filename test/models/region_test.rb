require "test_helper"
require 'webmock/minitest'

require_relative '../../app/models/jma_http_response_error'

class RegionTest < ActiveSupport::TestCase
  test 'pridが空だとエラー' do
    r = Region.new( name: 'りーじょんおぶずんだ' )
    assert_not r.valid?, 'Regionはpridを指定せずvalid?された'
    assert_not_nil r.errors[:prid]
  end

  test 'nameが空だとエラー' do
    r = Region.new( prid: '11111' )
    assert_not r.valid?, 'Regionはnameを指定せずvalid?された'
    assert_not_nil r.errors[:name]
  end

  test 'pridが重複しているとエラー' do
    r = Region.new( prid: '11111', name: 'りーじょんおぶずんだ' )
    r.save
    r_next = Region.new( prid: '11111', name: 'きりたんぽ' )
    assert_not r_next.valid?, 'Regionはpridが重複しているデータを指定されvalid?された'
    assert_not_nil r_next.errors[:prid]
  end

  test '正常値を設定してvalid?に成功した' do
    r = Region.new( prid: '11111', name: 'りーじょんおぶずんだ' )
    assert r.valid?
  end

  test 'HTTPエラーが発生した' do
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 500, body: '' )
    assert_raises( JmaHttpResponseError ) do
      Region.get_list()
    end
  end

  test 'データが1件も無かった' do
    regions = Region.all
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_no_data.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    assert_equal regions, Region.all
  end

  test 'データを1件読み込んだ' do
    regions = Region.all.to_a
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_one.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    region = ( Region.all.to_a - regions ).first
    assert_equal '19', region.prid
    assert_equal '釧路', region.name
  end

  test 'データを2件読み込んだ' do
    regions = Region.all.to_a
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_two.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    regions = ( Region.all.to_a - regions )
    assert_equal 2, regions.length
  end

  test '整形されたデータを取り込み' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_formatted.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    assert_equal 61, Region.all.count()
  end

  test '現行のデータを取り込み' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_raw.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    assert_equal 61, Region.all.count()
  end

  test '1件データを読み込んで、再度データを取り込み1件更新' do
    regions = Region.all.to_a
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_one.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    region = ( Region.all.to_a - regions ).first
    assert_equal '19', region.prid
    assert_equal '釧路', region.name

    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_one_updated.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    region = Region.where( id: region.id ).first
    assert_equal '19', region.prid
    assert_equal 'クッチャロ', region.name
  end

  test '複数件データを取り込んだ後、再度データを取り込み1件追加' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_formatted.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    assert_equal 61, Region.all.count()

    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_formatted_added.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    assert_equal 62, Region.all.count()
    region = Region.where( prid: '25' ).first
    assert region.present?
    assert_equal '詩棟', region.name
  end

  test '複数件データを取り込んだ後、再度データを取り込み1件更新' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_formatted.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    region_all = Region.all.count()
    assert_equal 61, Region.all.count()
    region = Region.where( prid: '14' ).first
    assert region.present?
    assert_equal '石狩', region.name

    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_formatted_updated.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    Region.get_list()
    assert_equal 61, Region.all.count()
    region = Region.where( prid: '14' ).first
    assert region.present?
    assert_equal 'しゃけ鍋', region.name
  end

  test '不正な形式のデータが存在した' do
    response_tag = File.read( Rails.root.join( 'test', 'response_data', 'region', 'top_station_one_invalid.html' ) )
    stub_request( :post, Constants::JAPAN_METEOROLOGICAL_AGENCY + Constants::JMA_SITE_TOP_STATION )
    .to_return( status: 200, body: response_tag )
    assert_raises( ActiveRecord::RecordInvalid ) do
      Region.get_list()
    end
  end
end
