class Admin::QuestionsController < Admin::BaseController
  def index
    @questions = Question.includes(:votes, :answers, :comments, :user).order(created_at: :desc)
    topic_query = params[:topic_id]
    sort_by = params[:sort]
    from = params[:from]
    to = params[:to]

    @questions = @questions.joins(:topics).where(topics: Topic.find_by(id: topic_query)) if topic_query.present?
    @questions = @questions.reorder("created_at #{sort_by}") if sort_by.present?
    @questions = @questions.from_date(from) if from.present?
    @questions = @questions.till_date(to) if to.present?
  end
end
