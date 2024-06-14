class CreateAppStates < ActiveRecord::Migration[7.1]
  def change
    create_table :app_states do |t|
      t.string :state

      t.timestamps
    end
  end
end
