class RenameClass2ToLectures < ActiveRecord::Migration
  def change
   rename_column :lectures, :class, :class_num 
  end
end
