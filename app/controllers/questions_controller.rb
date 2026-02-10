class QuestionsController < ApplicationController
    before_action :authenticate_user!, except: %i[index show]
    before_action :set_current_question, only: %i[show edit update destroy publish]
    before_action :authorize_question!, only: %i[edit update destroy]
    before_action :load_topics, only: %i[new show edit update]

    def index
      if params[:filter] == "current-user"
        @questions = current_user.questions
      elsif params[:user_id]
        @questions = User.find_by(:user_id).questions
      else
        @questions = Question.published
      end
    end

    def new
      @question = current_user.questions.new
    end

    def edit
    end

    def show
    end

    def create
      @question = current_user.questions.new(question_params)
      @question.status = params[:commit] == "Publish" ? :published : :draft

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
        flash.now[:alert] = "Question cannot be deleted"
        render :show, status: :unprocessable_entity
      end
    end

    def publish
      if @question.update(status: :published)
        p "hello"
        redirect_to @question, notice: "Question published successfully."
      else
        p "bye"
        redirect_to @question, alert: @question.errors.full_messages.to_sentence
      end
    end

    private

    def set_current_question
      @question = Question.find_by(url: params[:url]) || Question.find_by(id: params[:url])
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
end
