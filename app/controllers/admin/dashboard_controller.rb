class Admin::DashboardController < ApplicationController
  before_action :check_admin
  layout :admin_assets

  def index
  end

  private

    def check_admin
      unless current_user.is_admin?
        redirect_to root_path
        flash[:error] = 'You are not authorized to visit this page'
      end
    end

end
