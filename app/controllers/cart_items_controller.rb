class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    variant = Variant.find(params[:variant_id])
    item = @cart.cart_items.find_or_initialize_by(variant:)
    item.quantity = item.quantity.to_i + params[:quantity].to_i
    if item.save
      redirect_to cart_path, notice: 'Added to cart.'
    else
      redirect_back fallback_location: root_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @cart.cart_items.find(params[:id])
    item.update(quantity: params[:quantity])
    redirect_to cart_path
  end

  def destroy
    @cart.cart_items.find(params[:id]).destroy
    redirect_to cart_path
  end

  private
  def set_cart; @cart = Cart.find(session[:cart_id]); end
end
