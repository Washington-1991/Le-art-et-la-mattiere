class CartItemsController < ApplicationController
  before_action :set_cart

   def create
    article = Article.find(params[:article_id])
    cart_item = @cart.cart_items.find_or_initialize_by(article_id: article.id)
    cart_item.quantity += 1
    cart_item.price = article.price
    cart_item.save

    redirect_to cart_path, notice: "#{article.name} fue añadido al carrito"
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
