class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def update
    if @user.update_attributes(user_params)
      redirect_with_message(edit_user_registration_path, "Your profile has been updated.", "success")
    else
      redirect_with_message(edit_user_registration_path, @user.user_errors, "error")
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :full_name, :webpage, :signature, :location)
    end

end
