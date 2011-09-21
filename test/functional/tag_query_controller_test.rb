require 'test_helper'

class TagQueryControllerTest < ActionController::TestCase
  test "should get tag" do
    get :tag
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
