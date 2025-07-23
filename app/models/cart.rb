class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :articles, through: :cart_items

  def add_article(article_id)
    article = Article.find(article_id)

    if article.stock <= 0
      errors.add(:base, "Stock épuisé")
      return false
    end

    transaction do
      cart_item = cart_items.find_or_initialize_by(article_id: article.id)
      cart_item.quantity ||= 0
      cart_item.quantity += 1
      cart_item.price = article.price

      unless cart_item.save
        errors.add(:base, cart_item.errors.full_messages.join(", "))
        raise ActiveRecord::Rollback
      end

      update(total: calculate_total)
      article.decrement!(:stock)
    end
    true
  rescue => e
    errors.add(:base, e.message)
    false
  end

  def calculate_total
    cart_items.sum('quantity * price')
  end
end
