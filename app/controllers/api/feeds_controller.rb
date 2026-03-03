class Api::FeedsController < ApplicationController
  before_action :authenticate

  def index
    @topics = @user.topics
    @questions = Question.joins(:topics)
                  .where(topics: @topics)
                  .order(created_at: :desc)
                  .includes(:answers, :comments)
    render :index
  end

  private def authenticate
    @user = User.find_by(auth_token: params[:token])
    unless @user
      redirect_to root_path, alert: "Invalid authentication token"
    end
  end
end
