class TopicAssignementsController < ApplicationController
    before_action :authenticate_user!

    def create
      topicable = find_topicable
      topic = Topic.find(params[:add_topic_id])

      topicable.topic_assignements.find_or_create_by!(topic: topic)
      redirect_to user_path(topicable)
    end

    def destroy
      assignment = TopicAssignement.find(params[:id])
      topicable = assignment.topicable
      assignment.destroy
      redirect_to user_path(topicable)
    end

    private def find_topicable
        @topicable = params[:topicable_type].constantize.find(params[:topicable_id])
    end
end
