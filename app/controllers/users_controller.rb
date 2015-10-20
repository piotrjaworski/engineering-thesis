class UsersController < ApplicationController

  def index
    @users = User.includes(:topics, :posts).paginate(page: params[:page], per_page: 20)
  end

  def show
    @user = User.friendly.find(params[:id])
    @posts = @user.latest_posts
    @topics = @user.latest_topics
    @all = (@posts + @topics).sort { |a, b| a.created_at <=> b.created_at }.paginate(page: params[:page], per_page: 20)
    @posts = @posts.paginate(page: params[:page], per_page: 20)
    @topics = @topics.paginate(page: params[:page], per_page: 20)
    @posts_count = @user.latest_posts.count
    @topics_count = @user.latest_topics.count
    respond_to do |format|
      format.js
      format.html
    end
  end

end
