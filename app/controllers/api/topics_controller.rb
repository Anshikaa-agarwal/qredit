class Api::TopicsController < ApplicationController
  QUESTION_LIMIT = 7
  API_REQUEST_RATE_LIMIT = 50

  rate_limit to: API_REQUEST_RATE_LIMIT, within: 1.hour

  def show
    @topic = Topic.find_by("LOWER(name) = ?", params[:name].downcase)

    @questions = @topic.questions.order(created_at: :desc).limit(QUESTION_LIMIT).includes(:comments, :answers)

    respond_to do |format|
      format.json
    end
  end
end
