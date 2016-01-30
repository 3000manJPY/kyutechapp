class RemoveClassidFromLectures < ActiveRecord::Migration
  def change
    remove_column :lectures, :class_id, :integer
    change_column :lectures, :sub_id, :integer, :limit => 8
    change_column :lectures, :id, :integer, :limit => 8
    change_column :lectures, :created_at, :integer, :limit => 8
    change_column :lectures, :updated_at, :integer, :limit => 8
  end
end
