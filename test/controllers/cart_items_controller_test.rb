class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def create
    article = Article.find(params[:article_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(article: article)

    if @cart_item.persisted?
      @cart_item.increment!(:quantity)
    else
      @cart_item.quantity = 1
    end

    if @cart_item.save
      redirect_to cart_path, notice: "#{article.name} a été ajouté à votre panier"
    else
      redirect_to article_path(article), alert: "Impossible d'ajouter l'article: #{@cart_item.errors.full_messages.to_sentence}"
    end
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: "Quantité mise à jour."
    else
      redirect_to cart_path, alert: "Erreur lors de la mise à jour de la quantité."
    end
  end

  def destroy
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'Article supprimé du panier'
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
