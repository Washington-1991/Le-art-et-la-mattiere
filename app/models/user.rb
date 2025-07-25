# app/models/user.rb
class User < ApplicationRecord
  # Devise modules for authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Roles using enum (stored as strings)
  enum role: {
    customer: "customer",
    admin:    "admin"
  }

  # Associations
  has_many :carts, dependent: :destroy
  has_one  :current_cart, -> { order(created_at: :desc) }, class_name: 'Cart'

  # Alias so that user.cart returns the most recent cart
  def cart
    current_cart
  end

  # Returns the active cart or creates a new one
  def active_cart
    carts.order(created_at: :desc).first || carts.create
  end
end
