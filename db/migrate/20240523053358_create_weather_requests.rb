class CreateWeatherRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_requests do |t|
      t.references :observation_location, null: false, foreign_key: true
      t.datetime :observation_date_time, null: false
      t.string :status, null: false
      t.datetime :request_time, null: false
      t.datetime :success_time
      t.integer :retry_count, default: 0
      t.text :error_message
      t.references :measurement, null: true, foreign_key: true

      t.timestamps
    end
  end
end
