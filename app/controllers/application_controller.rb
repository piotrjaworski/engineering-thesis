class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :blocked?
  helper_method :logged_in?

  rescue_from CanCan::AccessDenied do
    if @topic.present?
      redirect_to topic_path(@topic), alert: 'You are not able to change this post'
    else
      redirect_to root_path, alert: 'You are not authorized to access this page'
    end
  end

  private

  def blocked?
    if user_signed_in? && current_user.blocked?
      sign_out current_user
      redirect_to root_path, alert: 'This account has been blocked'
    end
  end

  def logged_in?
    current_user
  end

  def check_admin
    render_404 if logged_in?.nil? || !logged_in?.admin?
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml  { head :not_found }
      format.json { head :not_found }
      format.js { head :not_found }
    end
  end
end
