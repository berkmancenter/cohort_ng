require 'test_helper'

class NoteQueryControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get upcoming" do
    get :upcoming
    assert_response :success
  end

  test "should get priority" do
    get :priority
    assert_response :success
  end

end
