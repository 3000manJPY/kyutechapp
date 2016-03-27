class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :name
      t.integer :direction_id

      t.timestamps null: false
    end
  end
end
