class AddAccessIdToAccessCampus < ActiveRecord::Migration
  def change
    add_column :access_campuses, :access_id, :integer
    add_column :access_campuses, :campus_id, :integer
  end
end
