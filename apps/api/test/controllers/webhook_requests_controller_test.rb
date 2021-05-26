require "test_helper"

class WebhookRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @webhook_request = webhook_requests(:one)
  end

  test "should get index" do
    get webhook_requests_url, as: :json
    assert_response :success
  end

  test "should create webhook_request" do
    assert_difference('WebhookRequest.count') do
      post webhook_requests_url, params: { webhook_request: { event: @webhook_request.event, status: @webhook_request.status, webhook: @webhook_request.webhook } }, as: :json
    end

    assert_response 201
  end

  test "should show webhook_request" do
    get webhook_request_url(@webhook_request), as: :json
    assert_response :success
  end

  test "should update webhook_request" do
    patch webhook_request_url(@webhook_request), params: { webhook_request: { event: @webhook_request.event, status: @webhook_request.status, webhook: @webhook_request.webhook } }, as: :json
    assert_response 200
  end

  test "should destroy webhook_request" do
    assert_difference('WebhookRequest.count', -1) do
      delete webhook_request_url(@webhook_request), as: :json
    end

    assert_response 204
  end
end
