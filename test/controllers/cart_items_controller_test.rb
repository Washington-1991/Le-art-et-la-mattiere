class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    @cart = current_user.cart || Cart.create(user: current_user)
    article = Article.find(params[:article_id])
    @cart_item = CartItem.new(cart: @cart, article: article)

    if @cart_item.save
      redirect_to cart_path(@cart), notice: "Article ajouté au panier."
    else
      redirect_to article_path(article), alert: "Erreur lors de l'ajout au panier."
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
