class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def admin_assets
    "admin"
  end

  def check_admin
    unless current_user.is_admin?
      redirect_with_message(root_path, "You are not authorized to visit this page", "error")
    end
  end

  def redirect_with_message(path, message, type)
    redirect_to path
    flash[type] = "#{message}"
  end

end
