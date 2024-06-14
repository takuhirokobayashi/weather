# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

## weather_symbol はIMGかSVGの予定
[
  [1, '快晴', '快晴', true, false],
  [2, '晴れ', '晴れ', true, true],
  [3, '薄曇', '薄曇', true, false],
  [4, '曇', '曇', true, true],
  [5, '煙霧', '煙霧', true, true],
  [6, '砂じん嵐', '砂じん嵐', true, false],
  [7, '地ふぶき', '地ふぶき', true, false],
  [8, '霧', '霧', true, true],
  [9, '霧雨', '霧雨', true, true],
  [10, '雨', '雨', true, true],
  [11, 'みぞれ', 'みぞれ', true, true],
  [12, '雪', '雪', true, true],
  [13, 'あられ', 'あられ', true, false],
  [14, 'ひょう', 'ひょう', true, true],
  [15, '雷', '雷', true, false],
  [16, 'しゅう雨または止み間のある雨', 'しゅう雨または止み間のある雨', false, true],
  [17, '着氷性の雨', '着氷性の雨', false, true],
  [18, '着氷性の霧雨', '着氷性の霧雨', false, true],
  [19, 'しゅう雪または止み間のある雪', 'しゅう雪または止み間のある雪', false, true],
  [22, '霧雪', '霧雪', false, true],
  [23, '凍雨', '凍雨', false, true],
  [24, '細氷', '細氷', false, true],
  [28, 'もや', 'もや', false, true],
  [101, '降水またはしゅう雨性の降水', '降水またはしゅう雨性の降水', false, true],
  [999, '天気設定無し', '天気設定無し', false, false],
].each do |row|
  WeatherSymbol.find_or_create_by!(
    weather_code: row[0],
    weather_symbol: row[1],
    weather: row[2],
    visual_observation: row[3],
    instrumental_observation: row[4]
  )
end

[
  '北', '北北東', '北東', '東北東', '東', '東南東', '南東', '南南東',
  '南', '南南西', '南西', '西南西', '西', '西北西', '北西', '北北西',
  '静穏', '風向設定無し'
].each do |direction|
  WindDirection.find_or_create_by!( compass_direction: direction )
end

ActiveRecord::Base.transaction do
  WeatherStation.get_list()
  Region.get_list()
  ## ObservationLocation.get_list は WeatherStation 及び Region が存在することが前提
  ObservationLocation.get_list()
rescue ActiveRecord::RecordInvalid => ex
  Rails.logger.error ex.class
  Rails.logger.error ex.record
  Rails.logger.error ex.record.errors.full_messages
rescue JmaHttpResponseError => ex
  Rails.logger.error ex.message
rescue InvalidAmedasFileError => ex
  Rails.logger.error ex.message
rescue => ex
  Rails.logger.error ex.message
end

AppState.destroy_all
AppState.set_down
