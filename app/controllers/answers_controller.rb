class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :authorize_answer!, only: %i[edit update destroy]
  before_action :set_question, only: %i[new create edit destroy]
  before_action :set_answer,   only: %i[edit update destroy]

  def index
    @answers = Answer.all
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.status = :published

    respond_to do |format|
      if @answer.save
        format.turbo_stream
        format.html { redirect_to @question, notice: "Answer posted successfully" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @answer.update(answer_content_params)
        format.turbo_stream
        format.html { redirect_to @question, notice: "Answer updated successfully" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @answer.destroy
        format.turbo_stream
        format.html { redirect_to @question, notice: "Answer deleted successfully" }
      else
        redirect_to @question
      end
    end
  end

  private def authorize_answer!
  end

  private def answer_content_params
    params.require(:answer).permit(:content)
  end

  private def answer_params
    params.require(:answer).permit(:id, :content)
  end

  private def set_answer
    @answer = Answer.find_by(id: params[:id])
  end

  private def set_question
    @question = Question.find_by(url: params[:question_url])
  end
end