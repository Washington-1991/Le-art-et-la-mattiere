class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index, :new, :create, :edit, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = current_user  # Cada usuario solo puede ver su propio perfil
  end

  private

  def authorize_admin
    redirect_to root_path, alert: "No tienes permiso para ver esto" unless current_user.admin?
  end
end
