class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.integer :campus_id
      t.integer :sub_id
      t.string :title
      t.string :teacher
      t.string :year
      t.integer :class_id
      t.string :term
      t.string :week_time

      t.timestamps null: false
    end
  end
end
