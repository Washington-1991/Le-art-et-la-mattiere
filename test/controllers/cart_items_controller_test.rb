class CartItemsController < ApplicationController
  before_action :set_cart

    def create
    # ... tu lógica actual para agregar al carrito ...
    respond_to do |format|
      format.html { redirect_to request.referer, notice: 'Artículo agregado al carrito' }
      format.js   # Esto permitiría respuestas AJAX si lo necesitas
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'Article supprimé du panier.'
  end

  private

  def set_cart
    @cart = current_cart
  end
end
