class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]

  # it's just update password method in fact
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    account_update_params_without_email = account_update_params
    account_update_params_without_email[:email] = self.resource.email

    resource_updated = update_resource(resource, account_update_params_without_email)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
        set_flash_message :success, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path + "#password"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :full_name, :email, :password) }
  end
end
