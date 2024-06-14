## https://www.data.jma.go.jp/gmd/risk/obsdl/top/help3.html
class WeatherSymbol < ApplicationRecord
  has_many :measurements

  validates :weather_code, numericality: { only_integer: true }, uniqueness: true
  validates :weather_symbol, presence: true
  validates :weather, presence: true
end
