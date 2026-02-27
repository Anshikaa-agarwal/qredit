class Admin::AnswersController < Admin::BaseController
  def index
    @answers = Answer.includes(:votes, :comments, :user).order(created_at: :desc)
    sort_by = params[:sort]
    from = params[:from]
    to = params[:to]

    @answers = @answers.reorder("created_at #{sort_by}") if sort_by.present?
    @answers = @answers.from_date(from) if from.present?
    @answers = @answers.till_date(to) if to.present?
  end
end
