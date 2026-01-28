class QuestionsController < ApplicationController
    before_action :set_current_user

    def index
      @questions = @user.questions
    end

    def new
      @question = Question.new
      load_topics
    end

    def create
        p params
      @question = Question.new(question_params)
      @question.user = @user
      @question.status = :published if params[:commit] == "Publish"
      puts @question

      if @question.save
        redirect_to @question, notice: "Question was successfully created."
      else
        load_topics
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_current_user
      @user = current_user
    end

    def load_topics
      @topics = Topic.all
    end

    def question_params
      params.require(:question).permit(:title, :content, :pdf, topic_ids: [])
    end
end
