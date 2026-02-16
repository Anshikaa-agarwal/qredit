class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable
  before_action :set_vote, only: [ :destroy ]

  def create
    @vote = @votable.votes.find_or_initialize_by(user: current_user)
    @vote.type = params[:vote][:type]

    respond_to do |format|
      if @vote.save
        flash.now[:notice] = "Vote casted successfully."
        format.turbo_stream
      else
        flash.now[:alert] = "Could not cast vote."
        format.html { redirect_back fallback_location: @votable }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @vote.destroy
        flash.now[:notice] = "Vote removed successfully."
        format.turbo_stream
      else
        flash.now[:alert] = "Could not remove vote."
        format.html { redirect_back fallback_location: @votable }
      end
    end
  end

  private def set_vote
    @vote = @votable.votes.find_by(id: params[:id])
  end

  private def vote_type_param
    params.require(:vote).permit(:type)
  end

  private def set_votable
    @votable = if params[:comment_id]
      Comment.find(params[:comment_id])
    elsif params[:answer_id]
      Answer.find(params[:answer_id])
    elsif params[:question_url]
      Question.find_by!(url: params[:question_url])
    else
      raise "No votable found"
    end
  end
end
