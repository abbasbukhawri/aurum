class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_order, only: [:show, :update]

  # GET /orders
  def index
    return render json: [] unless current_user

    @orders = current_user.orders.order(created_at: :desc)
    render json: @orders,
           include: { order_items: { include: { variant: { include: :product } } } }
  end

  # GET /orders/:id
  def show
    render json: @order,
           include: { order_items: { include: { variant: { include: :product } } } }
  end

  # POST /orders
  def create
    if current_user
      cart = current_user.carts.where(status: "active").order(created_at: :desc).first
    else
      cart = Cart.find_by(id: params[:cart_id], status: "active")
    end

    return render json: { error: "Cart is empty" }, status: :unprocessable_entity unless cart&.cart_items&.any?

    order_attrs = {
      cart: cart,
      number: SecureRandom.hex(5).upcase,
      status: "pending",
      payment_status: "unpaid",
      currency: "USD"
    }

    if current_user
      order = current_user.orders.create!(order_attrs)
    else
      order = Order.create!(
        order_attrs.merge(
          guest_first_name: params[:first_name],
          guest_last_name:  params[:last_name],
          guest_email:      params[:email],
          guest_phone:      params[:phone]
        )
      )

      otp = rand(100_000..999_999).to_s
      order.update!(otp_code: otp, otp_sent_at: Time.current)
      OrderMailer.with(order: order).guest_otp.deliver_now
    end

    cart.cart_items.each do |item|
      order.order_items.create!(
        variant:  item.variant,
        quantity: item.quantity
        # name, sku, price_cents, total_cents are set by callback
      )
    end

    cart.update!(status: "converted")

    render json: {
      success: true,
      order: order,
      message: ("OTP sent to #{order.guest_email}" unless current_user)
    }, status: :created
  end

  def verify_otp
    order = Order.find(params[:id])
    entered_otp = params[:otp].to_s

    if order.otp_code.present? &&
      order.otp_sent_at.present? &&
      order.otp_code == entered_otp &&
      order.otp_sent_at > 10.minutes.ago

      Order.transaction do
        order.update!(
          otp_verified: true,
          status: "confirmed",
          otp_code: nil,
          otp_sent_at: nil
        )

        # 🔹 Mark the cart as converted after successful confirmation
        order.cart&.update!(status: "converted")
      end

      render json: { message: "Order confirmed successfully!" }, status: :ok
    else
      render json: { error: "Invalid or expired OTP" }, status: :unprocessable_entity
    end
  end

  # PATCH /orders/:id
  def update
    if @order.update(order_params)
      render json: { success: true, order: @order }
    else
      render json: { success: false, errors: @order.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  # def set_order
  #   @order = current_user.orders.find(params[:id])
  # end
  def set_order
    if current_user
      @order = current_user.orders.find(params[:id])
    else
      @order = Order.find(params[:id])
    end
  end

  def order_params
    params.require(:order).permit(
      :status,
      :payment_status,
      :shipping_address_id,
      :billing_address_id
    )
  end
end
