class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :line_name
      t.string :station_name

      t.timestamps null: false
    end
  end
end
