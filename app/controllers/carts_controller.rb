# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_cart, only: [:show, :checkout]

  def show
    # @current_cart ya está cargado
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def checkout
    if @current_cart.cart_items.empty?
      redirect_to cart_path, alert: "Votre panier est vide" and return
    end

    @total      = @current_cart.total_price
    @cart_items = @current_cart.cart_items.includes(:article)
  end

  private

  def set_current_cart
    # Usa el helper de modelo para obtener o crear un carrito
    @current_cart = current_user.active_cart
  end
end
