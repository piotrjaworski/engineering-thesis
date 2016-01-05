class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  impressionist actions: [:show]

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def new
    @topic = Topic.new
    @topic.posts.build

    respond_to do |format|
      format.js do
        render :new, layout: false
      end
    end
  end

  def create
    @topic = Topic.build_new(current_user, topic_params)
    if @topic.save
      render :hide_form
    else
      render :show_errors, layout: false
    end
  end

  def edit
    return unless check_topic
  end

  def update
    return unless check_topic
    if @topic.update(topic_params)
      redirect_to @topic, notice: 'Topic has been saved'
    else
      render :edit
    end
  end

  def destroy
    return unless check_topic
    if @topic.destroy
      redirect_to root_path, notice: 'Topic has been removed'
    else
      redirect_to root_path, alert: 'Cannot destroy topic'
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
    redirect_to @topic, notice: 'Topic has been successfully closed'
  end

  def open
    @topic = Topic.find(params[:topic_id])
    authorize! :open, @topic
    @topic.open
    redirect_to @topic, notice: 'Topic has been successfully opened'
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :description, :category_id, posts_attributes: [:content])
  end

  def set_topic
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.paginate(page: params[:page])
  end

  def check_topic
    authorize! params[:action].to_sym, @topic
    if !@topic.can_delete?
      flash[:error] = "Cannot #{params[:action]} Topic"
      redirect_to @topic and return false
    else
      return true
    end
  end

  def not_found
    redirect_to root_path, alert: "This topic doesn't exist"
  end
end
