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
      redirect_with_message(@topic, @post.errors.messages.map { |k, v| "#{k.to_s.capitalize} #{v.join('')}" }.join(''), "error")
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
      redirect_to @topic
      flash[:success] = "Post has been successfuly updated"
    else
      redirect_to @topic, alert: "@post.errors.messages.map { |k, v| '#{k.to_s.capitalize} #{v.join('')}' }.join('')"
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
