class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title
      t.text :details
      t.integer :category_id
      t.integer :department_id
      t.integer :campus_id
      t.integer :date
      t.string :period_time
      t.string :grade
      t.string :place
      t.string :subject
      t.string :teacher
      t.string :before_data
      t.string :after_data
      t.string :web_url
      t.string :note
      t.string :document1_name
      t.string :document2_name
      t.string :document3_name
      t.string :document4_name
      t.string :document5_name
      t.string :document1_url
      t.string :document2_url
      t.string :document3_url
      t.string :document4_url
      t.string :document5_url
      t.integer :regist_time

      t.timestamps null: false
    end
  end
end
