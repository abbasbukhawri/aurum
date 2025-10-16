class CatalogController < ApplicationController
  def index
    @q = Product.visible.ransack(params[:q]) # name_or_sku_cont, category_id_eq, metal_id_eq, gemstones_name_cont, price range via variants
    @products = @q.result.includes(:category, :metal).page(params[:page]).per(24)
  end

  def show
    @product = Product.friendly.find(params[:id])
  end
end
