class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted? && !@user.blocked
      flash[:notice] = 'Successfully logged in with Google+'
      sign_in_and_redirect @user, event: :authentication
    elsif @user.blocked
      redirect_to root_path, alert: 'This account has been blocked'
    else
      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
