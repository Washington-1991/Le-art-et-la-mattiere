# app/models/user.rb
class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :carts, dependent: :destroy
  has_one  :current_cart, -> { order(created_at: :desc) }, class_name: 'Cart'

  # Alias para que current_user.cart devuelva siempre el carrito más reciente
  def cart
    current_cart
  end

  # Método que devuelve el carrito activo o crea uno nuevo
  def active_cart
    carts.order(created_at: :desc).first || carts.create
  end
end
