class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_topic, only: [:show]
  impressionist actions: [:show]

  def new
    respond_to do |format|
      format.js do
        @topic = Topic.new
        @topic.posts.build
      end
    end
  end

  def create
    @topic = Topic.build_new(current_user, topic_params)
    if @topic.save
      render :hide_form
    else
      redirect_to root_path, alert: "Please fill all required fields"
    end
  end

  def show
    impressionist(@topic)
    @post = Post.new
  end

  def close
    @topic = Topic.find(params[:topic_id])
    authorize! :close, @topic
    @topic.close
    redirect_to @topic, notice: "Topic has been successfully closed"
  end

  def open
    @topic = Topic.find(params[:topic_id])
    authorize! :open, @topic
    @topic.open
    redirect_to @topic, notice: "Topic has been successfully opened"
  end

  private

    def topic_params
      params.require(:topic).permit(:name, :description, :category_id, { posts_attributes: [:content] })
    end

    def set_topic
      @topic = Topic.find(params[:id])
      @posts = @topic.posts
    end

end
