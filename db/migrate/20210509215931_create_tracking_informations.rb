class CreateTrackingInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :tracking_informations do |t|
      t.string :tracking_number
      t.string :carrier
      t.string :status

      t.timestamps
    end
  end
end
