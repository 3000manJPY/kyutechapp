class AddDetailsToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :title_en, :string
    add_column :lectures, :class, :string
    add_column :lectures, :required, :integer
    add_column :lectures, :credit, :integer
    add_column :lectures, :purpose, :text
    add_column :lectures, :overview, :text
    add_column :lectures, :keyword, :text
    add_column :lectures, :plan, :text
    add_column :lectures, :evaluation, :text
    add_column :lectures, :book, :text
    add_column :lectures, :preparation, :text
  end
end
