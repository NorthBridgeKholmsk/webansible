require "test_helper"

class RunPlaybooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get run_playbooks_index_url
    assert_response :success
  end
end
