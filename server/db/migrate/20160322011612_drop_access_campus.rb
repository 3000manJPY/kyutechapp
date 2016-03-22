class DropAccessCampus < ActiveRecord::Migration
  def change
    drop_table :access_campuses
    drop_table :campuses

  end
end
