class UsersController < ApplicationController
  before_action :authenticate_user!  # Asegura que solo los usuarios autenticados puedan ver su perfil

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = current_user  # Obtiene el usuario autenticado
  end
end
