class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update_attributes(user_params.except(:webpage, :signature, :location)) &&
       current_user.profile.update_attributes(user_params.except(:full_name, :username))
      redirect_to edit_user_registration_path, notice: "Your profile has been updated"
    else
      redirect_to edit_user_registration_path, alert: current_user.user_errors
    end
  end

  def preferences
    if current_user.profile.update_attributes(user_params)
      redirect_to edit_user_registration_path + "#info", notice: "Preferences updated"
    else
      redirect_to edit_user_registration_path + "#info", alert: "Cannot update preferences"
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :full_name, :webpage, :signature, :location, :avatar,
                                 :post_notifications, :message_notifications)
  end
end
