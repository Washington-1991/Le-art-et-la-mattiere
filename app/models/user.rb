class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # campos basicos para usuarios basicos o cliente
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  # campos para usuarios administradores
  attribute :is_admin, :boolean, default: false
end
