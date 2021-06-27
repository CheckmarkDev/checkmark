require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @link = links(:one)
  end

  test "should get index" do
    get links_url, as: :json
    assert_response :success
  end

  test "should create link" do
    assert_difference('Link.count') do
      post links_url, params: { link: { description: @link.description, title: @link.title, url: @link.url, user_id: @link.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show link" do
    get link_url(@link), as: :json
    assert_response :success
  end

  test "should update link" do
    patch link_url(@link), params: { link: { description: @link.description, title: @link.title, url: @link.url, user_id: @link.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy link" do
    assert_difference('Link.count', -1) do
      delete link_url(@link), as: :json
    end

    assert_response 204
  end
end
