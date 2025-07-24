class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_cart, only: [:show, :checkout]

  def show
    # @current_cart ya está establecido por el before_action
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def checkout
    if @current_cart.cart_items.empty?
      redirect_to cart_path, alert: "Votre panier est vide"
      return
    end
    @total = @current_cart.total_price
    @cart_items = @current_cart.cart_items.includes(:article)
  end

  private

  def set_current_cart
    # Obtiene el carrito más reciente o crea uno nuevo
    @current_cart = current_user.carts.order(created_at: :desc).first || current_user.carts.create
  end
end
