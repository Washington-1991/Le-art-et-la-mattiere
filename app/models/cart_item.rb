class CartItem < ApplicationRecord
  belongs_to :cart, touch: true  # Actualiza timestamp del carrito al cambiar items
  belongs_to :article

  validates :quantity, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: :available_stock,
    message: ->(object, data) do
      if object.quantity > object.article.stock
        "Quantité excède le stock disponible (#{object.article.stock})"
      else
        "doit être un nombre positif"
      end
    end
  }

  validates :price, numericality: {
    greater_than_or_equal_to: 0,
    message: "doit être un prix valide"
  }

  before_validation :set_price_from_article
  after_save :update_cart_totals
  after_destroy :update_cart_totals
  after_destroy :restore_article_stock

  # Prix total pour cette ligne
  def total_price
    price * quantity
  end

  # Stock disponible actual
  def available_stock
    article.stock + (persisted? ? quantity_was.to_i : 0)
  end

  private

  def set_price_from_article
    self.price = article.price if article && price.blank?
  end

  def update_cart_totals
    cart.calculate_total if cart.persisted?
  end

  def restore_article_stock
    article.increment!(:stock, quantity) if article.persisted?
  end
end
