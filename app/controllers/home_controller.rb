class HomeController < ApplicationController

  def index
    @topics = Topic.all
  end

end
