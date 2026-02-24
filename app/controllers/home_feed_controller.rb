class HomeFeedController < ApplicationController
  def index
    base = Question.with_attached_pdf.includes(:topics, :votes, :answers, :comments, user: [ :followers, avatar_attachment: :blob ])
    if params[:query]
      term = params[:query][:content].to_s.strip

      if params[:query][:search_by] == "topic"
        topic_filter = Topic.sanitize_sql_like(term) + "%"
        @questions = base.joins(:topics)
                        .where("topics.name ILIKE ?", topic_filter)
                        .distinct
      else
        content_filter = Question.sanitize_sql_like(term) + "%"
        @questions = base.published.where("title ILIKE ?", content_filter)
      end
    else
      @questions = base.published.order(created_at: :desc)
    end
  end
end
