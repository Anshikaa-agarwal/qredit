class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_answer,   only: %i[edit update destroy]
  before_action :authorize_answer!, only: %i[edit update destroy]
  before_action :set_question, only: %i[new create edit update destroy]

  def index
    @answers = Answer.all
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_content_params)
    @answer.user = current_user
    @answer.status = :published

    respond_to do |format|
      if @answer.save
        flash.now[:notice] = "Successfully answered."
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
        flash.now[:notice] = "Successfully updated answer."
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
        flash.now[:notice] = "Successfully destroyed answer."
        format.turbo_stream
        format.html { redirect_to @question, notice: "Answer deleted successfully" }
      else
        redirect_to @question
      end
    end
  end

  private def authorize_answer!
    redirect_to root_path, alert: "Not authorized" unless @answer.user == current_user
  end

  private def answer_content_params
    params.require(:answer).permit(:content)
  end

  private def set_answer
    @answer = Answer.find_by(id: params[:id])

    unless @answer
      redirect_back fallback_location: root_path, alert: "Answer not found."
    end
  end

  private def set_question
    @question = Question.find_by(url: params[:question_url])

    unless @question
      redirect_back fallback_location: root_path, alert: "Question not found."
    end
  end
end
