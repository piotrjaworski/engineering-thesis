class PostsController < ApplicationController
  before_action :set_topic
  before_action :set_post, only: [:edit, :update]
  before_action :authenticate_user!

  def new
    @post = @topic.posts.new
  end

  def create
    @post = @topic.build_post(current_user, post_params)
    if @post.save
      redirect_with_message(@topic, "Your reply has been posted.", "success")
    else
      render :new
      flash.now[:error] = "Please fill all required fields"
    end
  end

  def edit
    authorize! :edit, @post
  end

  def update
    authorize! :update, @post
    if @post.update(post_params)
      redirect_to @topic
      flash[:success] = "Post has been successfuly updated"
    else
      render :edit
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def post_params
      params.require(:post).permit(:content)
    end

end
