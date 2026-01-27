class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_user

    def show
        @remaining_topics = Topic.all - @user.topics
    end

    def edit
    end

    def update
        if params[:remove_avatar]
            @user.avatar.delete
        end

        if params[:user] && params[:user][:avatar]
            @user.update!(profile_params)
        end

        if params[:topics]
            @user.topics << Topic.find(params[:topics])
        end

        redirect_to profile_path
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
