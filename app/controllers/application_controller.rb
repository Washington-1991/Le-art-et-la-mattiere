# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_cart

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_dashboard_path : root_path
  end

  private

  # Evita que el atributo :admin se pueda modificar vía formularios de Devise
  def configure_permitted_parameters
    # Solo permitimos parámetros seguros para sign_up y account_update
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email password password_confirmation current_password])
  end

  def current_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      session[:cart_id] = nil unless cart
      cart
    else
      cart = Cart.create(user: current_user)
      session[:cart_id] = cart.id
      cart
    end
  end
end
