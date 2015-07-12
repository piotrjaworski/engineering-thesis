class Admin::DashboardController < ApplicationController
  before_action :check_admin
  layout :admin_assets

  def index
    @categories = Category.all
  end

end
