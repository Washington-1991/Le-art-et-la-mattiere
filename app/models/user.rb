class User < ApplicationRecord
  # Configuración de Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Asociaciones corregidas
  has_many :carts, dependent: :destroy
  has_one :current_cart, -> { order(created_at: :desc) }, class_name: 'Cart'
  has_many :cart_items, through: :carts

  # Constantes para validaciones
  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  PASSWORD_FORMAT = /\A
    (?=.*\d)           # Debe contener al menos un número
    (?=.*[a-z])        # Debe contener al menos una minúscula
    (?=.*[A-Z])        # Debe contener al menos una mayúscula
    (?=.*[[:^alnum:]]) # Debe contener al menos un carácter especial
  /x

  # Atributos para seguridad
  attribute :failed_attempts, :integer, default: 0
  attribute :locked_at, :datetime
  attribute :last_activity_at, :datetime

  # Validaciones
  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: VALID_EMAIL_REGEX }

  validates :password,
    presence: true,
    length: { minimum: 8, maximum: 72 },
    format: { with: PASSWORD_FORMAT },
    if: :password_required?

  # Callbacks
  before_save :downcase_email
  before_create :set_initial_activity
  after_create :create_initial_cart

  # Métodos de seguridad
  def lock_access!
    update(locked_at: Time.current)
  end

  def unlock_access!
    update(locked_at: nil, failed_attempts: 0)
  end

  def access_locked?
    locked_at? && (locked_at > 30.minutes.ago)
  end

  def increment_failed_attempts
    update(failed_attempts: failed_attempts + 1)
    lock_access! if failed_attempts >= 5
  end

  def reset_failed_attempts
    update(failed_attempts: 0)
  end

  def update_activity
    update(last_activity_at: Time.current)
  end

  def inactive?
    last_activity_at && last_activity_at < 30.days.ago
  end

  # Métodos del carrito
  def active_cart
    current_cart || create_cart
  end

  def cart_total
    current_cart&.total_price || 0
  end

  def admin?
    role == "admin"
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def downcase_email
    self.email = email.downcase
  end

  def set_initial_activity
    self.last_activity_at = Time.current
  end

  def create_initial_cart
    carts.create unless current_cart
  end
end
