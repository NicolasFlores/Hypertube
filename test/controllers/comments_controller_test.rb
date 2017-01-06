require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get comments_add_url
    assert_response :success
  end

end
