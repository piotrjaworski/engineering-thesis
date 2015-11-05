class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.paginate(page: params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new_notifications
    @notifications = current_user.notifications.unread
    render json: @notifications.count.to_json
  end

end
