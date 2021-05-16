# frozen_string_literal: true

require 'test_helper'

class TaskCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_comment = task_comments(:one)
  end

  test 'should get index' do
    get task_comments_url, as: :json
    assert_response :success
  end

  test 'should create task_comment' do
    assert_difference('TaskComment.count') do
      post task_comments_url,
           params: { task_comment: { task_id: @task_comment.task_id, user_id: @task_comment.user_id } }, as: :json
    end

    assert_response 201
  end

  test 'should show task_comment' do
    get task_comment_url(@task_comment), as: :json
    assert_response :success
  end

  test 'should update task_comment' do
    patch task_comment_url(@task_comment),
          params: { task_comment: { task_id: @task_comment.task_id, user_id: @task_comment.user_id } }, as: :json
    assert_response 200
  end

  test 'should destroy task_comment' do
    assert_difference('TaskComment.count', -1) do
      delete task_comment_url(@task_comment), as: :json
    end

    assert_response 204
  end
end
