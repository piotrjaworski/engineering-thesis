class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
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
