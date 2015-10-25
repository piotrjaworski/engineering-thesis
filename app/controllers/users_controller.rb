class UsersController < ApplicationController

  def index
    @users = User.includes(:topics, :posts).paginate(page: params[:page], per_page: 20)
  end

  def show
    @user = User.friendly.find(params[:id])
    @posts_count = @user.latest_posts.count
    @topics_count = @user.latest_topics.count
  end

  def tab
    @user = User.find(params[:id])
    @tab = params[:tab]
    render_tab(@tab)
    render :tab
  end

  private

    def render_tab(tab)
      if tab == "all"
        @posts = @user.latest_posts
        @topics = @user.latest_topics
        @all = (@posts + @topics).sort { |a, b| a.created_at <=> b.created_at }.paginate(page: params[:page], per_page: 10)
      elsif tab == "topics"
        @topics = @user.latest_topics
        @topics = @topics.paginate(page: params[:page], per_page: 10)
      elsif tab == "posts"
        @posts = @user.latest_posts
        @posts = @posts.paginate(page: params[:page], per_page: 10)
      end
    end

end
