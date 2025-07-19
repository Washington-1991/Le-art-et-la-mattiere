class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    @article = Article.find(params[:article_id])

    if @cart.add_article(@article.id)
      redirect_to cart_path, notice: 'Produit ajouté au panier.'
    else
      redirect_to @article, alert: "Impossible d'ajouter l'article au panier"
    end
  end

  def destroy
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'Article supprimé du panier.'
  end

  private

  def set_cart
    @cart = current_cart
  end
end
