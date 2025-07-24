class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :articles, through: :cart_items

  # Método para añadir artículos (sin cambios)
  def add_article(article_id)
    article = Article.lock.find_by(id: article_id)

    unless valid_article?(article)
      Rails.logger.error "Article invalid: #{errors.full_messages}"
      return false
    end

    ActiveRecord::Base.transaction do
      cart_item = find_or_build_cart_item(article)

      unless save_cart_item(cart_item)
        Rails.logger.error "Failed to save cart item: #{errors.full_messages}"
        raise ActiveRecord::Rollback
      end

      update_totals(article)
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    log_error(e)
    false
  end

  # Resto de los métodos permanecen igual...
  # (Elimina el método complete! y cualquier referencia a status)
end
