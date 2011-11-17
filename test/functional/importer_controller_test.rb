require 'test_helper'

class ImporterControllerTest < ActionController::TestCase
  test "should get upload_file" do
    get :upload_file
    assert_response :success
  end

end
