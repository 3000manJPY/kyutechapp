class AddAccessIdToPatterns < ActiveRecord::Migration
  def change
    add_column :patterns, :access_id, :integer
  end
end
