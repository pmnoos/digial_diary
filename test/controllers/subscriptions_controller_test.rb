require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get subscriptions_index_url
    assert_response :success
  end

  test "should get pricing" do
    get subscriptions_pricing_url
    assert_response :success
  end

  test "should get upgrade" do
    get subscriptions_upgrade_url
    assert_response :success
  end
end
