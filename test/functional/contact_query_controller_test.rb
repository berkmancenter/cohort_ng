require 'test_helper'

class ContactQueryControllerTest < ActionController::TestCase
  test "should get recent" do
    get :recent
    assert_response :success
  end

  test "should get yours" do
    get :yours
    assert_response :success
  end

  test "should get all" do
    get :all
    assert_response :success
  end

  test "should get todo" do
    get :todo
    assert_response :success
  end

end
