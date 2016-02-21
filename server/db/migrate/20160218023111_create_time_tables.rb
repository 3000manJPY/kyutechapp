class CreateTimeTables < ActiveRecord::Migration
  def change
    create_table :time_tables do |t|
      t.integer :direction_id
      t.string :pattern_name
      t.string :time

      t.timestamps null: false
    end
  end
end
