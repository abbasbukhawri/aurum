require "test_helper"

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get addresses" do
    get checkout_addresses_url
    assert_response :success
  end

  test "should get payment" do
    get checkout_payment_url
    assert_response :success
  end

  test "should get confirm" do
    get checkout_confirm_url
    assert_response :success
  end
end
