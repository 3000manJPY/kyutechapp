class RemoveDirectionIdFromPatterns < ActiveRecord::Migration
  def change
    remove_column :patterns, :direction_id, :integer
  end
end
