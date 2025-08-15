class CartItemsController < ApplicationController
  def create
  end

  def destroy
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
end
