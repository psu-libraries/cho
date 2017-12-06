require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get HelloReact" do
    get pages_HelloReact_url
    assert_response :success
  end

end
