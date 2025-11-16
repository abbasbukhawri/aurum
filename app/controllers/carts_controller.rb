class CartsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_cart, only: [:show, :update, :destroy]

  # GET /carts
  def index
    return render json: [] unless current_user

    @carts = current_user.carts
    render json: @carts
  end

  # GET /carts/:id
  def show
    render json: @cart.to_json(
      include: {
        cart_items: {
          include: {
            variant: {
              include: :product
            }
          }
        }
      }
    )
  end

  # POST /carts (add to cart)
  def create
    variant  = Variant.find(params[:variant_id])
    quantity = [params[:quantity].to_i, 1].max

    cart = current_cart

    cart_item = cart.cart_items.find_or_initialize_by(variant_id: variant.id)
    cart_item.quantity += quantity

    if cart_item.save
      render json: {
        success: true,
        cart_item: cart_item,
        message: "#{variant.product.name} added to cart"
      }, status: :ok
    else
      render json: { success: false, errors: cart_item.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /carts/:id
  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  # DELETE /carts/:id
  def destroy
    @cart.destroy
    head :no_content
  end

  private

  def current_cart
    if current_user
      current_user.carts.where.not(status: "converted").order(created_at: :desc).first ||
        current_user.carts.create!(status: "active")
    else
      cart = Cart.find_by(id: session[:cart_id])

      if cart.nil? || cart.converted?
        cart = Cart.create!(status: "active")
        session[:cart_id] = cart.id
      end

      cart
    end
  end

  def set_cart
    if current_user
      @cart = current_user.carts.find(params[:id])
    else
      @cart = Cart.find_by(id: session[:cart_id])
      render json: { error: "Cart not found" }, status: :not_found unless @cart
    end
  end

  def cart_params
    params.require(:cart).permit(:status)
  end
end
