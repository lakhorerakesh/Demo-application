class VideosController < ApplicationController
	before_filter :authenticate_user!

	def index
		if params[:q].blank?
	  	@videos = Video.order('created_at DESC')
	  else
	    videos = Video.search params[:q]
	    @videos = videos.to_a
	  end
	end

	def new
	  @video = Video.new
	end

	def download_video
		@video = Video.find(params[:id])
		YoutubeDL.download @video.link
		flash[:notice] = 'Video download successfuly.'
		redirect_to videos_path
	end

	def create
	  @video = Video.new(video_params)
	  if @video.save
	    flash[:notice] = 'Video added!'
	    redirect_to videos_path
	  else
	    render 'new'
	  end
	end

	def video_params
		params.require(:video).permit(:link)
	end

end
