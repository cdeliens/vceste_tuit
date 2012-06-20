class TimelinesController < ApplicationController
  def index
    @timelines = Timeline.all
    gon.where = "home"
    render :layout => false
  end


  def show
  	if (params[:save] == "true")
  	  unless Timeline.exists?(hashtag: "##{params[:id]}")
  	    Timeline.create(:hashtag => "##{params[:id]}") 
  	  end
  	end
  	if Timeline.exists?(hashtag: "##{params[:id]}")
      @timeline = Timeline.find_by_hashtag("##{params[:id]}")
    else
      @timeline = Timeline.find_by_id(params[:id])
  	end
    gon.hashtag = @timeline.hashtag
  end
end
