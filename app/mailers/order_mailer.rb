# app/mailers/order_mailer.rb
class OrderMailer < ApplicationMailer
  default from: 'no-reply@yourstore.com'

  def guest_otp
    @order = params[:order]
    mail(to: @order.guest_email, subject: 'Your Order Verification Code')
  end
end
