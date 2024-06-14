class CreateRegions < ActiveRecord::Migration[7.1]
  def change
    create_table :regions do |t|
      t.string :prid, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
