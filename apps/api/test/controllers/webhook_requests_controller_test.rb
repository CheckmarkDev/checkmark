# frozen_string_literal: true

require 'test_helper'

class WebhookRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @webhook_request = webhook_requests(:one)
  end

  test 'should get index' do
    get webhook_requests_url, as: :json
    assert_response :success
  end

  test 'should destroy webhook_request' do
    assert_difference('WebhookRequest.count', -1) do
      delete webhook_request_url(@webhook_request), as: :json
    end

    assert_response 204
  end
end
