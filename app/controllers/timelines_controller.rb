class TimelinesController < ApplicationController
	def show
    @timeline = Timeline.find_by_id(params[:id])
    gon.hashtag = @timeline.hashtag
  end
end
