class Admin::UsersController < Admin::BaseController
  def index
    @users = User.includes(:questions, :answers, :comments, :votes)
  end
end
