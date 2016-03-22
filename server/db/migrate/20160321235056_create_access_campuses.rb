class CreateAccessCampuses < ActiveRecord::Migration
  def change
    create_table :access_campuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
