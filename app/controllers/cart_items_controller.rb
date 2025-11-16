class CartItemsController < ApplicationController
  # before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_cart

  # POST /cart_items
   def create
    variant = Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1

    # Find or initialize cart_item
    cart_item = @cart.cart_items.find_or_initialize_by(variant_id: variant.id)
    cart_item.quantity += quantity

    if cart_item.save
      render json: { 
        success: true, 
        message: "#{variant.product.name} added to cart", 
        cart_item: cart_item 
      }, status: :ok
    else
      render json: { success: false, errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /cart_items/:id
  def update
    cart_item = @cart.cart_items.find(params[:id])
    if cart_item.update(quantity: params[:quantity])
      render json: { success: true, cart_item: cart_item }
    else
      render json: { success: false, errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /cart_items/:id
  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    render json: { success: true, message: "Item removed from cart" }, status: :ok
  end

  private

  def set_cart
    @cart = if current_user
              current_user.carts.find_or_create_by(status: "active")
            else
              session[:cart_id] ||= Cart.create!(status: "active").id
              Cart.find(session[:cart_id])
            end
  end
end
