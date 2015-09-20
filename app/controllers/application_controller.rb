class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def redirect_with_message(path, message, type)
    redirect_to path
    flash[type] = "#{message}"
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
