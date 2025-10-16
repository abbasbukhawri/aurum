class CartsController < ApplicationController
  before_action :load_cart

  def show; end

  private
  def load_cart
    @cart = current_cart
  end

  def current_cart
    if session[:cart_id] && Cart.exists?(session[:cart_id])
      Cart.find(session[:cart_id])
    else
      cart = Cart.create!
      session[:cart_id] = cart.id
      cart
    end
  end
end
