class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def admin_assets
    "admin"
  end

end
