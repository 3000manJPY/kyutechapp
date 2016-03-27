class RemoveNameFromAccesses < ActiveRecord::Migration
  def change
    remove_column :accesses, :name, :string
  end
end
