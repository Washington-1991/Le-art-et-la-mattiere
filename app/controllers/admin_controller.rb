# app/controllers/admin/products_controller.rb
class Admin::ProductsController < ApplicationController
  def index
    redirect_to admin_products_path
  end
end
