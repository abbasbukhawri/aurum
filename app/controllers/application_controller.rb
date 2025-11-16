class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  include ActionController::Cookies

  # Keep CSRF for HTML forms
  protect_from_forgery with: :exception

  def current_cart
    if current_user
      current_user.carts.find_or_create_by(status: "active")
    else
      session[:cart_id] ||= Cart.create!(status: "active").id
      Cart.find(session[:cart_id])
    end
  end
end
