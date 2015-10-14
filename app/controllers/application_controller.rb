class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  rescue_from CanCan::AccessDenied do |exception|
    if !!@topic
      redirect_to topic_path(@topic)
      flash[:error] = "You can't edit edit this post"
    else
      redirect_to root_path
      flash.now[:error] = "You are not authorized to access this page"
    end
  end

  private

    def logged_in?
      current_user
    end

    def redirect_with_message(path, message, type)
      redirect_to path
      flash[type] = "#{message}"
    end

    def check_admin
      render_404 if logged_in?.nil? || !logged_in?.is_admin?
    end

    def render_404
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml  { head :not_found }
        format.json  { head :not_found }
        format.js  { head :not_found }
      end
    end

end
