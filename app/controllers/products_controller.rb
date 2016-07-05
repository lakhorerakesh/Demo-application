class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]
  
  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @products = Product.all
    @product = Product.create(product_params)
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
    @products = Product.all
    respond_to do |format|
      if @product.update_attributes(product_params)
        format.js
      end
    end
  end

  def delete
    @product = Product.find(params[:product_id])
  end

  def destroy
    @products = Product.all
    @product.destroy
  end

  def shoppe
    @products = Product.all
  end

private

  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :image, :description)
  end
end