class AddDetailsToAccesses < ActiveRecord::Migration
  def change
    add_column :accesses, :genre_id, :integer
    add_column :accesses, :station_id, :integer
    add_column :accesses, :line_id, :integer
    add_column :accesses, :direction_id, :integer
  end
end
