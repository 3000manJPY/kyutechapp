class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.string :direction_name
      t.integer :access_id

      t.timestamps null: false
    end
  end
end
