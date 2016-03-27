class DropAccessCampus < ActiveRecord::Migration
  def change
    drop_table :campuses

  end
end
