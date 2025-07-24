# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :user
  has_many   :cart_items, dependent: :destroy

  # Calcula el total sumando precio×cantidad de cada ítem
  def total_price
    cart_items.sum('price * quantity')
  end
end
