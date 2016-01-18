class PostsController < ApplicationController
  before_action :set_topic
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    @post = @topic.posts.new
    respond_to do |format|
      format.js
      format.html do
        redirect_to root_path
      end
    end
  end

  def create
    @post = @topic.build_post(current_user, post_params)
    if @post.save
      @post.topic.touch
      redirect_to topic_path(@topic, page: @topic.last_page), notice: 'Your reply has been posted'
    else
      redirect_to @topic, alert: show_errors
    end
  end

  def edit
    respond_to do |format|
      format.js { authorize! :edit, @post }
    end
  end

  def update
    authorize! :update, @post
    if @post.update(post_params)
      @post.topic.touch
      redirect_to @topic, notice: 'Post has been successfuly updated'
    else
      redirect_to @topic, alert: show_errors
    end
  end

  def destroy
    authorize! :destroy, @post
    @post.who_deletes = current_user
    if @post.destroy
      redirect_to @topic, notice: 'Post has been successfuly removed'
    else
      redirect_to @topic, alert: 'Cannot destroy requested post'
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

  def show_errors
    @post.errors.messages.map { |k, v| "#{k.to_s.capitalize} #{v.join('')}" }.join('')
  end

end
