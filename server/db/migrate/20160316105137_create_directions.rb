class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.string :name
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
