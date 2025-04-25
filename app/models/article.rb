class Article < ApplicationRecord
  CATEGORIES = ["Verre", "Carton", "Papier de soie", "Papier mâché", "Fils"].freeze

  # Asociaciones
  has_many :cart_items
  has_many :carts, through: :cart_items

  # Validaciones
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :image_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(["http", "https"]) }

  # Callbacks
  before_save :check_stock

  private

  def check_stock
    if stock <= 0
      errors.add(:stock, "Le stock est épuisé, cet article ne peut pas être vendu.")
      throw(:abort)
    end
  end
end
