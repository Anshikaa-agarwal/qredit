class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_current_question, only: %i[show edit update destroy publish]
  before_action :authorize_question!, only: %i[edit update destroy]
  before_action :load_topics, only: %i[new show edit update]
  before_action :set_user

  def index
    if params[:user_id]
      @heading = @user == current_user ? "My Questions" : "Questions"
      @questions = Question.includes(:topics, :votes, :answers, :comments, pdf_attachment: :blob)
                           .where(user: @user)
    else
      @questions = Question.published.includes(:topics, :votes, :answers, :comments, pdf_attachment: :blob)
    end
  end

  def new
    @question = current_user.questions.new
  end

  def edit
  end

  def show
    @active_tab = params[:tab] == "comments" ? :comments : :answers
  end

  def create
    @question = current_user.questions.new(question_params)
    @question.status = :draft

    if @question.save
      redirect_to @question, notice: "Question was successfully created."
    else
      load_topics
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      redirect_to question_path(@question), notice: "Question updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      redirect_to root_path, notice: "Question deleted successfully"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def publish
    if @question.update(status: :published)
      redirect_to @question, notice: "Question published successfully."
    else
      redirect_to @question, alert: @question.errors.full_messages.to_sentence
    end
  end

  private

  def set_current_question
    @question = Question.includes(
  :topics,
  :votes,
  comments: [:user, { votes: :user }],
  answers: [:user, :votes, { comments: [:user, { votes: :user }] }],
  pdf_attachment: :blob
).find_by(url: params[:url]) || Question.find_by(id: params[:url])
  end

  def authorize_question!
    redirect_to root_path, alert: "Not authorized" unless @question.user == current_user
  end

  def load_topics
    @topics = Topic.all
  end

  def question_params
    params.require(:question).permit(:title, :content, :pdf, topic_ids: [])
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end
end
