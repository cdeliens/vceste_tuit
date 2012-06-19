class TimelinesController < ApplicationController
  def index
    @timelines = Timeline.all
    gon.where = "home"
    render :layout => false
  end


  def show
    @timeline = Timeline.find_by_id(params[:id])
    gon.hashtag = @timeline.hashtag
  end
end
