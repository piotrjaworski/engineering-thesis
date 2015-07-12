class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def admin_assets
    "admin"
  end

  def check_admin
    unless current_user.is_admin?
      redirect_to root_path
      flash[:error] = 'You are not authorized to visit this page'
    end
  end

end
