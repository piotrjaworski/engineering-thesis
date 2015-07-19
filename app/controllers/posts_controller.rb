class PostsController < ApplicationController
  before_action :set_topic
  before_action :authenticate_user!

  def new
    @post = @topic.posts.new
  end

  private

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

end
