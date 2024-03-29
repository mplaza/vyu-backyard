class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_google_oauth2(request.env["omniauth.auth"])

      if @user
        if @user.persisted?
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
          sign_in_and_redirect @user, :event => :authentication
        end
      else
        flash[:danger] = "You must be logged in with a vyutv email address"
        session["devise.google_data"] = request.env["omniauth.auth"].select { |k, v| k == "email" }
        redirect_to new_user_session_path
      end
  end
end