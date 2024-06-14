require "test_helper"

class WeatherSymbolTest < ActiveSupport::TestCase
  test 'weather_codeが空だとエラー' do
    ws = WeatherSymbol.new( weather_symbol: 'ぴかぴかしんぼる', weather: 'おひさまぴかぴか' )
    assert_not ws.valid?, 'WeatherSymbolはweather_codeを指定せずvalid?された'
    assert_not_nil ws.errors[:weather_code]
  end

  test 'weather_codeが数字でないとエラー' do
    ws = WeatherSymbol.new( weather_code: 'aaaa', weather_symbol: 'ぴかぴかしんぼる', weather: 'おひさまぴかぴか' )
    assert_not ws.valid?, 'WeatherSymbolはweather_codeに数字以外が指定されてvalid?された'
    assert_not_nil ws.errors[:weather_code]
  end

  test 'weather_codeが重複しているとエラー' do
    ws = WeatherSymbol.new( weather_code: '1111', weather_symbol: 'ぴかぴかしんぼる', weather: 'おひさまぴかぴか' )
    ws.save
    ws_next = WeatherSymbol.new( weather_code: '1111', weather_symbol: 'ぽかぽかしんぼる', weather: 'おひさまぽかぽか' )
    assert_not ws_next.valid?, 'WeatherSymbolはweather_codeが重複しているデータを指定されvalid?された'
    assert_not_nil ws_next.errors[:prid]
  end

  test 'weather_symbolが空だとエラー' do
    ws = WeatherSymbol.new( weather_code: '1111', weather: 'おひさまぴかぴか' )
    assert_not ws.valid?, 'WeatherSymbolはweather_symbolを指定せずvalid?された'
    assert_not_nil ws.errors[:weather_symbol]
  end

  test 'weatherが空だとエラー' do
    ws = WeatherSymbol.new( weather_code: '1111', weather_symbol: 'ぴかぴかしんぼる' )
    assert_not ws.valid?, 'WeatherSymbolはweatherを指定せずvalid?された'
    assert_not_nil ws.errors[:weather]
  end

  test '正常値を設定してvalid?に成功した' do
    ws = WeatherSymbol.new( weather_code: '1111', weather_symbol: 'ぴかぴかしんぼる', weather: 'おひさまぴかぴか' )
    assert ws.valid?
  end
end
