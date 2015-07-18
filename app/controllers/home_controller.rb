class HomeController < ApplicationController

  def index
    @topics = Topic.page(params[:page]).per_page(30)
  end

end
