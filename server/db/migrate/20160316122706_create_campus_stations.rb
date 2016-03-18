class CreateCampusStations < ActiveRecord::Migration
  def change
    create_table :campus_stations do |t|
      t.integer :campus_id
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
