class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:show, :checkout]

  def show
    # @cart ya está establecido por el before_action
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def checkout
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Votre panier est vide"
      return
    end

    # Lógica adicional para preparar el pago podría incluir:
    @total = @cart.total_price
    @cart_items = @cart.cart_items.includes(:article)

    # Aquí podrías inicializar algún objeto relacionado con el pago
    # @payment = Payment.new(amount: @total, user: current_user)
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
    # Alternativa más robusta para manejar múltiples carritos:
    # @cart = current_user.carts.in_progress.first || current_user.carts.create
  end
end
