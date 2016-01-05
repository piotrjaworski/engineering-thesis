class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]

  def update
    if current_user.update_with_password(user_params)
      sign_in current_user, bypass: true
      redirect_to edit_user_registration_path + '#password', notice: 'Password has been changed successfully.'
    else
      redirect_to edit_user_registration_path + '#password', alert: "#{current_user.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    redirect_to root_path, alert: 'Cannot destroy your account'
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :full_name, :email, :password) }
  end
end
