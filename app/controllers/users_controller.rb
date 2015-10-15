class UsersController < ApplicationController

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def show
    @user = User.friendly.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page], per_page: 20)
    @topics = @user.topics.paginate(page: params[:page], per_page: 20)
    @posts_count = @user.posts.count
    @topics_count = @user.topics.count
    @all = (@posts.to_a + @topics.to_a).shuffle.paginate(page: params[:page], per_page: 20)
  end

end
