class PostsController < ApplicationController
  before_action :set_topic
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

  private

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def post_params
      params.require(:post).permit(:content)
    end

end
