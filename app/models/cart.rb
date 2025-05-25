class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :articles, through: :cart_items

  def calculate_total
    cart_items.sum('quantity * price')
  end
end
