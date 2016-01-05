class SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.blocked?
      sign_out resource
      redirect_to root_path, alert: 'This account has been blocked'
    else
      super
    end
  end
end
