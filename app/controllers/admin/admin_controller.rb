class Admin::AdminController < ApplicationController
  before_action :check_admin
  layout :admin_assets

  private

    def admin_assets
      "admin"
    end

    def check_admin
      current_user ||= User.new
      render_404 unless current_user.is_admin?
    end

end
