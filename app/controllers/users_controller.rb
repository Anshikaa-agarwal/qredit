class UsersController < ApplicationController
    before_action :authenticate_user!, only: [ :update_profile ]
    before_action :set_user, only: [ :show ]
    before_action :set_current_user, only: [ :update_profile ]

    def show
      @remaining_topics = (Topic.all - @user.topics) if viewing_own_profile?
    end

    def update_profile
      if params[:remove_avatar]
        @current_user.avatar.attach(
          io: File.open(Rails.root.join("app/assets/images/placeholder_user_avatar.png")),
          filename: "placeholder_user_avatar.png"
        )
      end

      if params[:user]&.[](:avatar)
        @current_user.update!(user_params)
      end

      if params[:topics]
        @current_user.topics << Topic.find(params[:topics])
      end

      if params[:remove_topic]
        @current_user.topics.delete(Topic.find(params[:remove_topic]))
      end

      redirect_to user_path(@current_user)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def set_current_user
      @current_user = current_user
    end

    def user_params
      params.require(:user).permit(:avatar)
    end

    def viewing_own_profile?
      user_signed_in? && @user == current_user
    end
end
