class Api::TopicsController < ApplicationController
  QUESTION_LIMIT = 7

  def show
    @topic = Topic.find_by("LOWER(name) = ?", params[:name].downcase)

    @questions = @topic.questions.order(created_at: :desc).limit(10).includes(:comments, :answers)

    respond_to do |format|
      format.json
    end
  end
end
