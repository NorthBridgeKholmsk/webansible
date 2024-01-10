require "test_helper"

class HostRolesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get host_roles_index_url
    assert_response :success
  end

  test "should get new" do
    get host_roles_new_url
    assert_response :success
  end

  test "should get show" do
    get host_roles_show_url
    assert_response :success
  end

  test "should get create" do
    get host_roles_create_url
    assert_response :success
  end

  test "should get edit" do
    get host_roles_edit_url
    assert_response :success
  end

  test "should get update" do
    get host_roles_update_url
    assert_response :success
  end

  test "should get destroy" do
    get host_roles_destroy_url
    assert_response :success
  end
end
