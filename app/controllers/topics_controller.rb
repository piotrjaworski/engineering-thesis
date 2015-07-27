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
      format.html { redirect_to root_path }
    end
  end

  def create
    @topic = Topic.build_new(current_user, topic_params)
    if @topic.save
      @topics = Topic.page(params[:page]).per_page(30)
      flash.now[:success] = "Your topic has been created"
      render :hide_form
    end
  end

  def show
    impressionist(@topic)
  end

  private

    def topic_params
      params.require(:topic).permit(:name, :description, :category_id, { posts_attributes: [:content] })
    end

    def set_topic
      @topic = Topic.find(params[:id])
    end

end
