class RemoveStationIdFromAccessCampus < ActiveRecord::Migration
  def change
    remove_column :access_campuses, :name, :string
  end
end
