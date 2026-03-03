class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[ disable ]
  def index
    @users = User.includes(:questions, :answers, :comments, :votes)
  end

  def disable
    @user.disabled = true

    if @user.save
      redirect_to admin_users_path, notice: "User disabled successfully."
    else
      redirect_to admin_users_path, alert: "Could not disable user."
    end
  end

  private def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      redirect_back fallback_location: root_path, alert: "User not found"
    end
  end
end
