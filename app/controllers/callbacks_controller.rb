class CallbacksController < Devise::OmniauthCallbacksController
  def marvin
    @user = User.from_omniauth(request.env["omniauth.auth"])
    session[:me] = @user.email
    session[:id_user] = @user.id
    sign_in_and_redirect @user
  end
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    session[:me] = @user.email
    session[:id_user] = @user.id
    sign_in_and_redirect @user
  end
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    session[:me] = @user.email
    session[:id_user] = @user.id
    sign_in_and_redirect @user
  end
end
