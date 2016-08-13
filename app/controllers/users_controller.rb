class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.where.not("id = ?",current_user.id).order("created_at DESC")
    @conversations = Conversation.involving(current_user).order("created_at DESC")
  end

  def match_list
  	matches = HTTParty.get("http://cricapi.com/api/cricket")
  	@matches = matches.parsed_response["data"]
  end

  def live_score
  	match = HTTParty.post("http://cricapi.com/api/cricketScore?unique_id=#{params[:match_id]}")
  	@match = match.parsed_response
  end
end