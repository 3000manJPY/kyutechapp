class RemoveLineIdFromAccesses < ActiveRecord::Migration
  def change
    remove_column :accesses, :line_id, :integer
  end
end
