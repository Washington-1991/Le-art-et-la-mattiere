class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_cart

  def show
    # Lógica básica sin estado
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_current_cart
    @current_cart = current_user.carts.order(created_at: :desc).first || current_user.carts.create
  end
end
