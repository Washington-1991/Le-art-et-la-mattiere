class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_dashboard_path : root_path
  end

  helper_method :current_cart

  private

  def current_cart
    if user_signed_in?
      current_user.cart || current_user.create_cart
    else
      # Manejar carrito para invitados si es necesario
      if session[:cart_id]
        Cart.find_by(id: session[:cart_id]) || create_guest_cart
      else
        create_guest_cart
      end
    end
  end

  def create_guest_cart
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
end
