class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :authorize_comment!, only: %i[edit update destroy]
  before_action :set_comment, only: %i[ edit update destroy ]

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_content_params)
    @comment.user = current_user
    @comment.status = :published

    respond_to do |format|
      if @comment.save
        flash.now[:notice] = "Commented successfully."
        format.turbo_stream
      else
        flash.now[:alert] = "Could not comment."
        format.html { redirect_back fallback_location: (@commentable&.question || @commentable) }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_content_params)
        flash.now[:notice] = "Comment updated successfully."
        format.turbo_stream
        format.html { redirect_back fallback_location: (@commentable&.question || @commentable) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        flash.now[:notice] = "Comment deleted successfully."
        format.turbo_stream
        format.html { redirect_to @question, notice: "Comment deleted successfully" }
      else
        flash.now[:alert] = "Could not delete comment."
        format.html { redirect_back fallback_location: (@commentable&.question || @commentable) }
      end
    end
  end

  private def authorize_comment!
    set_comment
    redirect_to root_path, alert: "Not authorized" unless @comment.user == current_user
  end

  private def set_commentable
    @commentable = if params[:answer_id]
      Answer.find(params[:answer_id])
    elsif params[:question_url]
      Question.find_by!(url: params[:question_url])
    else
      raise "No commentable found"
    end
  end

  private def set_comment
    @comment = @commentable.comments.find_by(id: params[:id])
  end

  private def comment_content_params
    params.require(:comment).permit(:content)
  end
end
