class FollowersController < ApplicationController
  before_action :set_user
  before_action :set_destroy_relation

  def create
    @relation = current_user.following_relationships.new(followee: @user)

    respond_to do |format|
      if @relation.save
        flash.now[:notice] = "Successfully followed #{@user.name}"
        format.turbo_stream
      else
        flash.now[:alert] = "Could not follow #{@user.name}"
      end
    end
  end

  def destroy
    respond_to do |format|
      if @destroy_relation.destroy
        flash.now[:notice] = "Successfully unfollowed #{@user.name}"
        format.turbo_stream
      else
        flash.now[:alert] = "Could not unfollow #{@user.name}"
      end
    end
  end

  private def set_user
    @user = User.find_by(username: params[:user_username])

    unless @user
      redirect_back fallback_location: root_path, alert: "User not found."
    end
  end

  private def set_destroy_relation
    @destroy_relation = Follower.find_by(id: params[:id])
  end
end
