# frozen_string_literal: true

require 'test_helper'

class EmailNotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @email_notification = email_notifications(:one)
  end

  test 'should get index' do
    get email_notifications_url, as: :json
    assert_response :success
  end

  test 'should create email_notification' do
    assert_difference('EmailNotification.count') do
      post email_notifications_url,
           params: {
             email_notification: {
               comment: @email_notification.comment,
               like: @email_notification.like,
               newsletter: @email_notification.newsletter,
               user_id: @email_notification.user_id
             }
           }, as: :json
    end

    assert_response 201
  end

  test 'should show email_notification' do
    get email_notification_url(@email_notification), as: :json
    assert_response :success
  end

  test 'should update email_notification' do
    patch email_notification_url(@email_notification),
          params: {
            email_notification: {
              comment: @email_notification.comment,
              like: @email_notification.like,
              newsletter: @email_notification.newsletter,
              user_id: @email_notification.user_id
            }
          }, as: :json
    assert_response 200
  end

  test 'should destroy email_notification' do
    assert_difference('EmailNotification.count', -1) do
      delete email_notification_url(@email_notification), as: :json
    end

    assert_response 204
  end
end
