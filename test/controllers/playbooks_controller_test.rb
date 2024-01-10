require "test_helper"

class PlaybooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get playbooks_index_url
    assert_response :success
  end
end
