json.array!(@lectures) do |lecture|
#  json.extract! lecture, :id, :campus_id, :sub_id, :title, :teacher, :year, :class_id, :term, :week_time, :room
#  json.url lecture_url(lecture, format: :json)
  json.extract! lecture, :id, :campus_id, :sub_id, :title, :teacher, :year, :class_num, :term, :week_time, :room ,:title_en, :required, :credit, :purpose, :overview, :keyword, :plan, :evaluation, :book, :preparation

end
