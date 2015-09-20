class Admin::DashboardController < Admin::AdminController

  def index
    @categories = Category.all
  end

end
