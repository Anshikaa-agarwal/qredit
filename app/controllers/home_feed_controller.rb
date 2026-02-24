class HomeFeedController < ApplicationController
  before_action :set_current_user

  def index
    if params[:query]
      term = params[:query][:content].to_s.strip

      if params[:query][:search_by] == "topic"
        topic_filter = Topic.sanitize_sql_like(term) + "%"
        @questions = Question.includes(:topics)
                             .joins(:topics)
                             .where("topics.name ILIKE ?", topic_filter)
                             .distinct
      else
        content_filter = Question.sanitize_sql_like(term) + "%"
        @questions = Question.published
                             .includes(:topics)
                             .where("title ILIKE ?", content_filter)
      end
    else
      @questions = Question.published
                           .includes(:topics)
                           .order(created_at: :desc)
    end
  end

  private def set_current_user
    @user = current_user
  end
end
