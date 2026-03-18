class HomeFeedController < ApplicationController
  def index
    scope = Question.with_attached_pdf.includes(:topics, :votes, :answers, :comments, :abuse_reports, user: [ :followers, avatar_attachment: :blob ]).published
    if params[:query]
      term = params[:query][:content].to_s.strip

      if params[:query][:search_by] == "topic"
        topic_filter = "%" + Topic.sanitize_sql_like(term) + "%"
        @questions = scope.joins(:topics)
                        .where("topics.name ILIKE ?", topic_filter)
                        .distinct
      else
        content_filter = "%" + Question.sanitize_sql_like(term) + "%"
        @questions = scope.where("title ILIKE ?", content_filter)
      end
    else
      @questions = scope.order(created_at: :desc)
    end
  end
end
