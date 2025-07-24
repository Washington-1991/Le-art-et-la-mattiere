class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :articles, through: :cart_items

  # Añade un artículo al carrito con manejo completo
  def add_article(article_id)
    article = Article.lock.find_by(id: article_id)

    unless article_valid?(article)
      Rails.logger.error "Article invalid: #{errors.full_messages}"
      return false
    end

    ActiveRecord::Base.transaction do
      cart_item = build_or_increment_cart_item(article)

      unless save_cart_item(cart_item)
        Rails.logger.error "Failed to save cart item: #{errors.full_messages}"
        raise ActiveRecord::Rollback
      end

      update_totals_and_stock(article)
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e)
    false
  end

  # Precio total actual (calculado dinámicamente)
  def total_price
    cart_items.includes(:article).sum { |item| item.article.price * item.quantity }
  end

  # Total persistido (para evitar cálculos frecuentes)
  def calculate_total
    update_column(:total, cart_items.sum('quantity * price'))
  end

  private

  def article_valid?(article)
    errors.add(:base, "Article inexistant") && return false if article.nil?
    errors.add(:base, "Stock épuisé") && return false if article.stock <= 0
    true
  end

  def build_or_increment_cart_item(article)
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

  def update_totals_and_stock(article)
    calculate_total
    article.decrement!(:stock)
    Rails.logger.info "Article #{article.id} added to cart #{id}"
  end

  def handle_error(exception)
    errors.add(:base, "Erreur système: #{exception.message}")
    Rails.logger.error "Cart Error: #{exception.message}\n#{exception.backtrace.join("\n")}"
  end
end
