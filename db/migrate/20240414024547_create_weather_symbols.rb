class CreateWeatherSymbols < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_symbols do |t|
      t.integer :weather_code, null: false
      t.string :weather_symbol, null: false
      t.string :weather, null: false
      t.boolean :visual_observation, default: false, null: false
      t.boolean :instrumental_observation, default: false, null: false

      t.timestamps
    end
  end
end
