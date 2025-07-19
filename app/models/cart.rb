class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :articles, through: :cart_items

    def add_article(article_id)
    article = Article.find(article_id)

    if article.stock <= 0
      errors.add(:base, "Cet article est en rupture de stock")
      return false
    end

    existing_item = cart_items.find_by(article_id: article_id)

    if existing_item
      existing_item.quantity += 1
      existing_item.save
    else
      cart_items.create(
        article: article,
        quantity: 1,
        price: article.price
      )
    end
    true
  end # ← ESTE end faltaba para cerrar add_article

  def calculate_total
    cart_items.sum('quantity * price')
  end
end
