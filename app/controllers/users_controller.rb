class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :update_profile, :credits ]
  before_action :set_user, only: [ :show ]
  before_action :set_current_user, only: [ :update_profile ]

  def show
    @remaining_topics = (Topic.all - @current_user.topics) if viewing_own_profile?
  end

  def update_profile
    if params[:remove_avatar]
      @current_user.avatar.destroy
    end

    if params[:user]&.[](:avatar)
      @current_user.update!(user_params)
    end

    redirect_to user_path(@current_user)
  end

  def credits
    @credit_count = current_user.credits
    @transactions = current_user.credit_transactions
  end

  def followers
    @user = User.find_by(id: params[:user_id])
    @followers = @user.followers
    @followees = @user.followees
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def set_current_user
    @current_user = current_user
  end

  def user_avatar_params
    params.require(:user).permit(:avatar)
  end

  def viewing_own_profile?
    user_signed_in? && @user == current_user
  end
end
