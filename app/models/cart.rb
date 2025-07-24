class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :articles, through: :cart_items

  # Estados del carrito
  enum status: { active: 0, completed: 1, abandoned: 2 }, default: :active

  # Añade un artículo al carrito con manejo completo
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

  # Precio total actual (calculado dinámicamente)
  def total_price
    cart_items.joins(:article).sum('cart_items.quantity * articles.price')
  end

  # Total persistido (para evitar cálculos frecuentes)
  def update_totals
    update_columns(
      total: total_price,
      updated_at: Time.current
    )
  end

  # Marcar carrito como completado
  def complete!
    update(status: :completed, completed_at: Time.current)
  end

  private

  def valid_article?(article)
    errors.add(:base, "Article inexistant") && return false if article.nil?
    errors.add(:base, "Stock épuisé pour #{article.name}") && return false if article.stock <= 0
    true
  end

  def find_or_build_cart_item(article)
    cart_items.find_or_initialize_by(article_id: article.id).tap do |item|
      item.quantity ||= 0
      item.quantity += 1
      item.price = article.price
    end
  end

  def save_cart_item(cart_item)
    cart_item.save.tap do |success|
      errors.merge!(cart_item.errors) unless success
    end
  end

  def update_totals(article)
    article.decrement!(:stock)
    update_totals
    Rails.logger.info "Article #{article.id} added - Cart #{id} updated"
  end

  def log_error(exception)
    errors.add(:base, "Erreur système: #{exception.message}")
    Rails.logger.error "Cart Error: #{exception.message}\n#{exception.backtrace.join("\n")}"
  end
end
