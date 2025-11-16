class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = Product.all
    @products = @products.where(type: params[:type]) if params[:type].present?
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.where(visible: params[:visible]) if params[:visible].present?

    render json: @products
  end

  def show
    render json: @product
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :slug,
      :sku,
      :category_id,
      :metal_id,
      :description,
      :weight_grams,
      :base_price_cents,
      :currency,
      :visible,
      :type
    )
  end

  def authenticate_admin!
    unless current_user&.admin?
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end
end
