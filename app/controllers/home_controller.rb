class HomeController < ApplicationController
  protect_from_forgery except: [:index]

  def index
    @topics = Topic.paginate(page: params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def topic_filter
    type = params[:type]
    @topics = if type == 'top'
                Topic.top_records.paginate(page: params[:page])
              elsif type == 'new'
                Topic.new_records.paginate(page: params[:page])
              else
                Topic.paginate(page: params[:page])
              end
  end

  def category_filter
    @category = Category.find(params[:category])
    @topics = @category.topics.paginate(page: params[:page])
    respond_to do |format|
      format.js
    end
  end
end
