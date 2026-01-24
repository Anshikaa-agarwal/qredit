class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!
  # before_action :ensure_verified_user 

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private

  # Redirect unverified users to a notice page or sign-in
  # def ensure_verified_user
  #   return unless current_user

  #   unless current_user.verified?
  #     sign_out current_user
  #     flash[:alert] = "Please verify your email before accessing the site."
  #     redirect_to new_user_session_path
  #   end
  # end

  # Redirect after login
  # def after_sign_in_path_for(resource)
  #   root_path  # home feed
  # end
end
