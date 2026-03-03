class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable
  before_action :set_vote, only: [ :destroy ]

  def create
    @vote = @votable.votes.find_or_initialize_by(user: current_user)
    @vote.type = params[:vote][:type]

    respond_to do |format|
      if @vote.save
        flash.now[:notice] = "#{@vote.type.capitalize} casted successfully."
        format.turbo_stream
      else
        flash.now[:alert] = "Could not cast #{@vote.type.capitalize}."
        format.html { redirect_back fallback_location: @votable }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @vote.destroy
        flash.now[:notice] = "#{@vote.type.capitalize} removed successfully."
        format.turbo_stream
      else
        flash.now[:alert] = "Could not remove #{@vote.type.capitalize}."
        format.html { redirect_back fallback_location: @votable }
      end
    end
  end

  private def set_vote
    @vote = @votable.votes.find_by(id: params[:id])

    unless @vote
      redirect_back fallback_location: root_path, alert: "Vote not found."
    end
  end

  private def vote_type_param
    params.require(:vote).permit(:type)
  end

  private def set_votable
    @votable = if params[:comment_id]
      Comment.find_by(id: params[:comment_id])
    elsif params[:answer_id]
      Answer.find_by(id: params[:answer_id])
    elsif params[:question_url]
      Question.find_by(url: params[:question_url])
    end

    unless @votable
      redirect_back fallback_location: root_path, alert: "Some error occured."
    end
  end
end
