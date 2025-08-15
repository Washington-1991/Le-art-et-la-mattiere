# app/models/cart.rb
class Cart < ApplicationRecord
  # Actualiza el atributo total (si existe) con el valor actual
  def calculate_total
    if self.respond_to?(:total)
      update(total: total_price)
    end
    total_price
  end
  belongs_to :user
  has_many   :cart_items, dependent: :destroy

  # Calcula el total sumando precio×cantidad de cada ítem
  def total_price
    cart_items.sum('price * quantity')
  end
end
