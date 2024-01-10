require "test_helper"

class HostTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get host_types_index_url
    assert_response :success
  end

  test "should get new" do
    get host_types_new_url
    assert_response :success
  end

  test "should get create" do
    get host_types_create_url
    assert_response :success
  end

  test "should get edit" do
    get host_types_edit_url
    assert_response :success
  end

  test "should get update" do
    get host_types_update_url
    assert_response :success
  end

  test "should get destroy" do
    get host_types_destroy_url
    assert_response :success
  end
end
