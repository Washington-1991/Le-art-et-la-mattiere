class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :articles, through: :cart_items

  def add_article(article_id)
    existing_item = cart_items.find_by(article_id: article_id)

    if existing_item
      existing_item.quantity += 1
      existing_item.save
    else
      article = Article.find(article_id)
      cart_items.create(article: article, quantity: 1, price: article.price)
    end
  end  # ← ESTE end faltaba para cerrar add_article

  def calculate_total
    cart_items.sum('quantity * price')
  end
end
