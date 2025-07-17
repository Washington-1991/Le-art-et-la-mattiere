class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    @cart = current_cart
    @article = Article.find(params[:article_id])
    @cart_item = @cart.cart_items.create(article: @article)

    redirect_to @article, notice: "Ajouté au panier"
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
