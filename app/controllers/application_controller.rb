class ApplicationController < ActionController::Base
   before_action :authenticate_user!
   before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  def after_sign_in_path_for(resource)
    account_path(resource)
  end
end
