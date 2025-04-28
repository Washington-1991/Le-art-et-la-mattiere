class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :articles, through: :cart_items
end
