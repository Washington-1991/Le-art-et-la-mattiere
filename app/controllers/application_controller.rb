class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_dashboard_path : root_path
  end

  helper_method :current_cart

  private

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    if session[:cart_id]
      Cart.find_by(id: session[:cart_id]) || create_cart
    else
      create_cart
    end
  end

  def create_cart
    cart = Cart.create(user: current_user)
    session[:cart_id] = cart.id
    cart
  end
end
