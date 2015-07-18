class TopicsController < ApplicationController

  def new
    @topic = Topic.new
    @topic.posts.build
  end

  def create
    @topic = current_user.topics.new(topic_params)
    @topic.assing_user(current_user)
    if @topic.save
      @topics = Topic.all
      flash[:success] = "Your topic has been created"
      render :hide_form
    end
  end

  private

    def topic_params
      params.require(:topic).permit(:name, :description, :category_id, { posts_attributes: [:content] })
    end

end
