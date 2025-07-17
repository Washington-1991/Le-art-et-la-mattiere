class CartItemsController < ApplicationController
  before_action :set_cart

   # app/controllers/cart_items_controller.rb
def create
  @cart_item = current_user.cart.cart_items.create(article_id: params[:article_id])
  redirect_to cart_path, notice: "Ajouté au panier."
end
  end

  private

  def set_cart
    @cart = current_cart
  end

  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: 'Article supprimé du panier.'
  end

  private

  def set_cart
    @cart = if session[:cart_id]
              Cart.find_by(id: session[:cart_id]) || Cart.create.tap { |c| session[:cart_id] = c.id }
            else
              Cart.create.tap { |c| session[:cart_id] = c.id }
            end
  end
end
