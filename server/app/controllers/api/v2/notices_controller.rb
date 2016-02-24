class Api::V2::NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :edit, :update, :destroy]

  def allNotices
    @campus_id = params[:campus_id]
    if @campus_id == nil
        @notices = Notice.where("date >= ?", (Time.now - 3.day).to_i)
    else
        @notices = Notice.where("campus_id = ?  and date >= ?", @campus_id , (Time.now - 3.day).to_i)
    end
    render json: @notices
  end

  def redirect
    @id = params[:id]
    @notice = Notice.find_by(:id => @id)

  end
  def webPage
    redirect_to 'https://db.jimu.kyutech.ac.jp/cgi-bin/cbdb/db.cgi?page=DBRecord&did=391&qid=all&vid=24&rid=50&Head=&hid=&sid=n&rev=0&ssid=3-693-26272-g181'

  end
  def notice
    @id = params[:id]
    @notice = Notice.find_by(:id => @id)
    render json: @notice

  end
end
