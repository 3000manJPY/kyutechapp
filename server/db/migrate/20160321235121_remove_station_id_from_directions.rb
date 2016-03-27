class RemoveStationIdFromDirections < ActiveRecord::Migration
  def change
    remove_column :directions, :station_id, :integer
  end
end
