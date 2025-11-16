class Admin::OrdersController < ApplicationController
  # before_action :authenticate_admin!
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /admin/orders
  def index
    @orders = Order.includes(:user, :order_items).order(created_at: :desc)
    render json: @orders.as_json(
      include: {
        user: { only: [:id, :email, :first_name, :last_name] },
        order_items: { include: { variant: { include: :product } } }
      }
    )
  end

  # GET /admin/orders/:id
  def show
    render json: @order.as_json(
      include: {
        user: { only: [:id, :email, :first_name, :last_name] },
        order_items: { include: { variant: { include: :product } } }
      }
    )
  end

  # PATCH /admin/orders/:id
  def update
    if @order.update(order_params)
      render json: { success: true, order: @order }
    else
      render json: { success: false, errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /admin/orders/:id
  def destroy
    @order.destroy
    render json: { success: true, message: "Order deleted" }
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :payment_status, :tracking_number, :cancelled_reason)
  end

  def authenticate_admin!
    unless current_user&.admin?
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end
end
