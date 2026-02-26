class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin?

  layout 'admin'

  private def check_if_admin?
    unless current_user.role == "admin"
      redirect_to root_path, alert: "Admin access needed"
    end
  end
end
