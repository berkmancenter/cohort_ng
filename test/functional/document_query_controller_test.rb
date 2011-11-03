require 'test_helper'

class DocumentQueryControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get recent" do
    get :recent
    assert_response :success
  end

  test "should get yours" do
    get :yours
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
