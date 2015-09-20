class Admin::DashboardController < Admin::AdminController

  def index
    @categories = Category.all.take(5)
    @users = User.all.take(5)
    @topics = Topic.all.take(5)
  end

end
