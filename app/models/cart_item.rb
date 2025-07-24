class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :article

  def total_price
    article.price * quantity
  end
end
