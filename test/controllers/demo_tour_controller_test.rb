require "test_helper"

class DemoTourControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get demo_tour_show_url
    assert_response :success
  end
end
