class Api::V2::LecturesController < ApplicationController
  before_action :set_lecture, only: [:show, :edit, :update, :destroy]

  @LECTURE_UPDATE_TIME = "com.planningdev.kyutech.update"
  def allLectures
    @campus_id = params[:campus_id]
    @server_time = params[:server_time]
    if @campus_id == nil
      @lectures = Lecture.all
    else
      @lectures = Lecture.where("campus_id = ?", @campus_id)
    end
    @SYLLABUS_UPDATE_TIME = "com.planningdev.kyutech.lecture.update"
    @cache_time = (Rails.cache.read @SYLLABUS_UPDATE_TIME)
    if @server_time == nil || @cache_time == nil
        render json: { "data" => @lectures, "server_time" => @cache_time}
    else
      if @server_time.to_i == @cache_time.to_i
        render json: { "data" => Array.new, "server_time" => @cache_time}
      else
        render json: { "data" => @lectures, "server_time" => @cache_time}
      end
    end
  end

  def lecture
    @id = params[:id]
    render json: Lecture.find_by(:id => @id) 
  end

end
