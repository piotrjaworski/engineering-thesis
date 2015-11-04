class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.paginate(page: params[:page])
  end

  def new_notifications
    @notifications = current_user.notifications.unread
    render json: @notifications.count.to_json
  end

end
