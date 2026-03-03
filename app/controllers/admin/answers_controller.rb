class Admin::AnswersController < Admin::BaseController
  before_action :set_answer, only: %i[ unpublish ]
  def index
    @answers = Answer.includes(:question, :votes, :comments, :user).order(created_at: :desc)
    sort_by = params[:sort]
    from = params[:from]
    to = params[:to]

    @answers = @answers.reorder("created_at #{sort_by}") if sort_by.present?
    @answers = @answers.from_date(from) if from.present?
    @answers = @answers.till_date(to) if to.present?
  end

  def unpublish
    @answer.status = :unpublished

    if @answer.save
      redirect_to admin_answers_path, notice: "Answer unpublished successfully."
    else
      redirect_to admin_answers_path, alert: "Could not unpublish answer."
    end
  end

  private def set_answer
    @answer = Answer.find_by(id: params[:id])
    unless @answer
      redirect_back fallback_location: root_path, alert: "No answer found."
    end
  end
end
