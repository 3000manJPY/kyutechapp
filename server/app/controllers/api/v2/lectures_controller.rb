class Api::V2::LecturesController < ApplicationController
  before_action :set_lecture, only: [:show, :edit, :update, :destroy]

  @LECTURE_UPDATE_TIME = "com.planningdev.kyutech.update"
  def allLectures
    @campus_id = params[:campus_id]
    if @campus_id == nil
      @lectures = Lecture.all
    else
      @lectures = Lecture.where("campus_id = ?", @campus_id)
    end
    @SYLLABUS_UPDATE_TIME = "com.planningdev.kyutech.lecture.update"
    render json: { "data" => @lectures, "server_time" => (Rails.cache.read @SYLLABUS_UPDATE_TIME)}
  end

  def lecture
    @id = params[:id]
    render json: Lecture.find_by(:id => @id) 
  end

  def getServerTime
      render_to_string :lecture_update_time => Rails.cache.read @LECTURE_UPDATE_TIME

  end

end
