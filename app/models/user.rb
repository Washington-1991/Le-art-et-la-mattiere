class User < ApplicationRecord
  # Elimina has_secure_password
  # has_secure_password

  # Devise para manejar la autenticación
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Asociaciones
  has_many :carts, dependent: :destroy

  # Constantes para la seguridad
  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  PASSWORD_FORMAT = /\A
    (?=.*\d)           # Debe contener al menos un número
    (?=.*[a-z])        # Debe contener al menos una minúscula
    (?=.*[A-Z])        # Debe contener al menos una mayúscula
    (?=.*[[:^alnum:]]) # Debe contener al menos un carácter especial
  /x

  # Atributos para el control de intentos fallidos
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

  # Métodos de seguridad
  def lock_access!
    self.locked_at = Time.current
    save
  end

  def unlock_access!
    self.locked_at = nil
    self.failed_attempts = 0
    save
  end

  def access_locked?
    locked_at? && (locked_at > 30.minutes.ago)
  end

  def increment_failed_attempts
    self.failed_attempts += 1
    if failed_attempts >= 5
      lock_access!
    else
      save
    end
  end

  def reset_failed_attempts
    update_columns(failed_attempts: 0)
  end

  def update_activity
    update_column(:last_activity_at, Time.current)
  end

  def inactive?
    last_activity_at < 30.days.ago
  end

  # Método para verificar si el usuario es administrador
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
end
