class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_cart_item, only: [:update, :destroy]
  before_action :validate_stock, only: [:create, :update]

  def create
    article = Article.find(params[:article_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(article: article)

    respond_to do |format|
      if process_cart_item(article)
        format.html { redirect_to cart_path, notice: success_message(article) }
        format.turbo_stream { flash.now[:notice] = success_message(article) }
      else
        format.html { redirect_to article_path(article), alert: error_message }
        format.turbo_stream { flash.now[:alert] = error_message }
      end
    end
  end

  def update
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to cart_path, notice: "Quantité mise à jour avec succès." }
        format.turbo_stream
      else
        format.html { redirect_to cart_path, alert: @cart_item.errors.full_messages.to_sentence }
        format.turbo_stream { flash.now[:alert] = @cart_item.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @cart_item.destroy
    respond_to do |format|
      format.html { redirect_to cart_path, notice: 'Article supprimé du panier' }
      format.turbo_stream
    end
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def validate_stock
    article = @cart_item&.article || Article.find(params[:article_id])
    return unless article.stock <= 0

    respond_to do |format|
      format.html { redirect_to request.referer || articles_path, alert: "Stock épuisé pour #{article.name}" }
      format.turbo_stream { flash.now[:alert] = "Stock épuisé pour #{article.name}" }
    end
  end

  def process_cart_item(article)
    if @cart_item.persisted?
      @cart_item.increment(:quantity)
    else
      @cart_item.quantity = 1
    end

    @cart_item.save
  end

  def success_message(article)
    quantity = @cart_item.quantity
    "#{quantity} #{'article'.pluralize(quantity)} #{article.name} #{quantity > 1 ? 'ont' : 'a'} été ajouté au panier"
  end

  def error_message
    @cart_item.errors.full_messages.to_sentence.presence || "Erreur inconnue lors de l'ajout au panier"
  end
end
