class ApplicationController < ActionController::Base
  # Devise: ensure user is authenticated for most actions
  before_action :authenticate_user!

  # Set default redirect path after login based on role
  def after_sign_in_path_for(resource)
    resource.admin? ? admin_dashboard_path : root_path
  end

  # Expose current_cart helper to views
  helper_method :current_cart

  private

  # Return or initialize the current user's cart (logged in or guest)
  def current_cart
    if user_signed_in?
      current_user.cart || current_user.create_cart
    else
      guest_cart
    end
  end

  # Create a guest cart and store in session
  def guest_cart
    if session[:cart_id]
      Cart.find_by(id: session[:cart_id]) || build_guest_cart
    else
      build_guest_cart
    end
  end

  # Helper to build and persist a guest cart
  def build_guest_cart
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  # Authorization filter: only allow admins
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Acceso denegado. Solo administradores."
    end
  end
end
