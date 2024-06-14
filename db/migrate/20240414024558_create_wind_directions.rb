class CreateWindDirections < ActiveRecord::Migration[7.1]
  def change
    create_table :wind_directions do |t|
      t.string :compass_direction, null: false

      t.timestamps
    end
  end
end
