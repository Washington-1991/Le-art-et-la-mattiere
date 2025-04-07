# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password,  null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :reset_password_token_expires_at  # Nueva columna para expiración de token

      ## Rememberable
      t.datetime :remember_created_at
      t.string   :remember_token  # Token adicional para remember me

      ## Trackable (importante para seguridad)
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable (verificación de email)
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable (protección contra fuerza bruta)
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at

      ## Seguridad adicional
      t.datetime :password_changed_at  # Para invalidar tokens cuando cambia la contraseña
      t.string   :otp_secret_key  # Para autenticación de dos factores
      t.boolean  :otp_required, default: false  # Habilitar 2FA

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    add_index :users, :remember_token,       unique: true
    add_index :users, :password_changed_at   # Para auditoría
  end
end
