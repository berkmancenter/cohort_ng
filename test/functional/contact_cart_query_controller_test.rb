require 'test_helper'

class ContactCartQueryControllerTest < ActionController::TestCase
  test "should get my" do
    get :my
    assert_response :success
  end

  test "should get all" do
    get :all
    assert_response :success
  end

end
