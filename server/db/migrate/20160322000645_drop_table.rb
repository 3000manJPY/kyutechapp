class DropTable < ActiveRecord::Migration
  def change
    #  drop_table :campus_stations
      drop_table :line_stations
  end
end
