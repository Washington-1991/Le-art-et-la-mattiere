# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_cart_item, only: [:update, :destroy]
  before_action :validate_stock, only: [:create, :update]

  def create
    article   = Article.find(params[:article_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(article: article)

    respond_to do |format|
      if process_cart_item(article)
        format.html         { redirect_to cart_path, notice: success_message(article) }
        format.turbo_stream { flash.now[:notice] = success_message(article) }
      else
        format.html         { redirect_to article_path(article), alert: error_message }
        format.turbo_stream { flash.now[:alert] = error_message }
      end
      # fallback para otros Accept headers
      format.any { head :ok }
    end
  end

  def update
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html         { redirect_to cart_path, notice: "Quantité mise à jour avec succès." }
        # si tienes un partial por item, renderiza su replace; si no, redirige
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@cart_item) }
      else
        msg = @cart_item.errors.full_messages.to_sentence
        format.html         { redirect_to cart_path, alert: msg }
        format.turbo_stream { flash.now[:alert] = msg }
      end
      format.any { head :ok }
    end
  end

  def destroy
    # destroy! lanzará excepción si falla; usamos destroy y comprobamos
    destroyed = @cart_item.destroy

    respond_to do |format|
      if destroyed
        format.html         { redirect_to cart_path, notice: "Article supprimé du panier." }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@cart_item) }
      else
        msg = @cart_item.errors.full_messages.to_sentence.presence || "Impossible de supprimer l'article."
        format.html         { redirect_to cart_path, alert: msg }
        format.turbo_stream { flash.now[:alert] = msg }
      end
      format.any { head :ok }
    end
  end

  # Vaciar completamente el carrito
  def clear
    @cart.cart_items.destroy_all
    respond_to do |format|
      format.html         { redirect_to cart_path, notice: "Le panier a été vidé avec succès." }
      format.turbo_stream # asume que tienes un stream que limpia la lista en la vista
      format.any { head :ok }
    end
  end

  private

  def set_cart
    # Evita crear carritos “fantasma”; usa el activo del usuario
    @cart = current_user.active_cart
  end

  def set_cart_item
    # Importantísimo: buscar SIEMPRE dentro del carrito del usuario
    @cart_item = @cart.cart_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    # Si el item no pertenece a este carrito o no existe
    respond_to do |format|
      format.html         { redirect_to cart_path, alert: "Élément introuvable dans votre panier." }
      format.turbo_stream { flash.now[:alert] = "Élément introuvable dans votre panier." }
      format.any { head :not_found }
    end
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def validate_stock
    article = @cart_item&.article || Article.find(params[:article_id])
    return if article.stock > 0

    respond_to do |format|
      msg = "Stock épuisé pour #{article.name}"
      format.html         { redirect_to (request.referer || articles_path), alert: msg }
      format.turbo_stream { flash.now[:alert] = msg }
      format.any { head :see_other }
    end
    # ¡Cortar la acción! (antes no cortaba y seguía ejecutando create/update)
    return
  end

  def process_cart_item(article)
    if @cart_item.persisted?
      @cart_item.increment(:quantity)
    else
      @cart_item.quantity = 1
    end
    # si guardas precio “snapshot” en cart_items, setéalo aquí:
    # @cart_item.price ||= article.price
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
