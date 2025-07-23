class CartsController < ApplicationController
  # carts_controller.rb
  def show
    @cart = current_user.carts.last # or whatever logic you use to find the current cart
    # or if you have a way to mark a cart as "current":
    # @cart = current_user.carts.where(status: 'active').first
  end
end
