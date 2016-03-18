class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.time :time
      t.integer :pattern_id

      t.timestamps null: false
    end
  end
end
