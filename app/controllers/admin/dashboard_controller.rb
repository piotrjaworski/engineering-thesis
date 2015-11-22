class Admin::DashboardController < Admin::AdminController
  def index
    @categories = Category.take(5)
    @users = User.take(5)
    @topics = Topic.take(5)
    @posts = Post.take(5)
  end
end
