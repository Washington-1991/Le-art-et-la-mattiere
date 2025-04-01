class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  before_action :authorize_admin, only: [:admin_dashboard]

  def admin_dashboard
    # Renderiza la vista solo si es admin
  end

  private

  def authorize_admin
    redirect_to root_path, alert: "No tienes acceso a esta página." unless current_user.admin?
  end

  def home
  end
end
