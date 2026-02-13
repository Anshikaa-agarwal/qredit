class TopicAssignementsController < ApplicationController
    before_action :set_topicable
    before_action :set_topic_assignement, only: %i[destroy]

    def create
      @topic_assignement = TopicAssignement.new(
        topic_id: params[:add_topic_id],
        topicable: @topicable
      )

      if @topic_assignement.save
        redirect_to @topicable
      else
        redirect_to @topicable, alert: "Could not add topic"
      end
    end

    def destroy
        if @topic_assignement.destroy
            redirect_to @topicable
        else
          redirect_to @topicable, alert: "Could not delete topic"
        end
    end

    private def set_topicable
        if params[:user_id]
            @topicable = User.find_by(id: params[:user_id])
        elsif params[:question_id]
            @topicable = Question.find_by(id: params[:question_id])
        end
    end

    private def set_topic_assignement
        @topic_assignement = TopicAssignement.find_by(id: params[:id])
    end
end
