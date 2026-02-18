class FollowersController < ApplicationController
  before_action :set_user
  before_action :set_destroy_relation

  def create
    @relation = current_user.following_relationships.new(followee: @user)

    if @relation.save
      flash[:notice] = "Successfully followed #{@user.email}"
      redirect_back fallback_location: root_path
    else
      flash[:alert] = "Could not follow #{@user.email}"
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    if @destroy_relation.destroy
      flash[:notice] = "Successfully unfollowed #{@user.email}"
      redirect_back fallback_location: root_path
    else
      flash[:notice] = "Could not unfollow #{@user.email}"
      redirect_back fallback_location: root_path
    end
  end

  private def set_user
    @user = User.find_by(id: params[:user_id])
  end

  private def set_destroy_relation
    @destroy_relation = Follower.find_by(id: params[:id])
  end
end
