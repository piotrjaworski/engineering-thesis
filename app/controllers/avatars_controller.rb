class AvatarsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def reload
    flash.now[:success] = current_user.get_avatar
  end

  def edit
  end

  def update
    current_user.update(avatar_params)
    redirect_to edit_user_registration_path
    flash.now[:success] = "Avatar has been updated"
  end

  private

    def avatar_params
      params.require(:user).permit(:avatar, :gravatar)
    end

end
