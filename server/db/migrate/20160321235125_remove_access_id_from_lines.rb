class RemoveAccessIdFromLines < ActiveRecord::Migration
  def change
    remove_column :lines, :access_id, :integer
  end
end
