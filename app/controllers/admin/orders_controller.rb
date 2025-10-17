class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]

    def index
    @orders = Order.includes(:user, :order_items).order(created_at: :desc)

    render json: {
      orders: ActiveModelSerializers::SerializableResource.new(@orders, each_serializer: OrderSerializer),
      meta: { total: @orders.count }
    }
  end

  def show
    render json: {
      order: ActiveModelSerializers::SerializableResource.new(@order, serializer: OrderSerializer)
    }
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: 'Order updated successfully.'
    else
      render :show, alert: 'Failed to update order.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :payment_status, :shipping_status)
  end
end
