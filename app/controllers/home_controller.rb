class HomeController < ApplicationController
  protect_from_forgery except: [:index]

  def index
    @topics = Topic.page(params[:page]).per_page(30)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def topic_filter
    type = params[:type]
    @topics = if type == "top"
      Topic.top_records.page(params[:page]).per_page(30)
    elsif type == "new"
      Topic.new_records.page(params[:page]).per_page(30)
    else
      Topic.page(params[:page]).per_page(30)
    end
  end

  def category_filter
    @category = Category.find(params[:category])
    @topics = @category.topics.page(params[:page]).per_page(30)
    respond_to do |format|
      format.js
    end
  end

end
