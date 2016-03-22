class AddCampusIdToAccesses < ActiveRecord::Migration
  def change
    add_column :accesses, :campus_id, :integer
  end
end
