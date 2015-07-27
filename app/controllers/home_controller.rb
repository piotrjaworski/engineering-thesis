class HomeController < ApplicationController

  def index
    @topics = Topic.page(params[:page]).per_page(30)
    respond_to do |format|
      format.js
      format.html
    end
  end

end
