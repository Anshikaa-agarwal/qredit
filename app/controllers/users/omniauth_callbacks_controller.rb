class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    auth = request.env["omniauth.auth"]

    unless auth
      redirect_to new_user_session_path, alert: "Google authentication failed."
      return
    end

    @user = User.from_omniauth(auth)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
