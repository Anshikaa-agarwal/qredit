class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_user

    def show
        @remaining_topics = Topic.all - @user.topics
    end

    def edit
    end

    def update
    end

    def remove_associated_topic
        topic = Topic.find(params[:id])
        @user.topics.delete(topic)
        redirect_to profile_path
    end

    private def profile_params
        params.require(:user).permit(:avatar)
    end

    private def set_current_user
        @user = current_user
    end
end
