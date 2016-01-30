class AddRoomToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :room, :string
  end
end
