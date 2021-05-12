# frozen_string_literal: true

require 'test_helper'

class TaskLikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_like = task_likes(:one)
  end

  test 'should get index' do
    get task_likes_url, as: :json
    assert_response :success
  end

  test 'should create task_like' do
    assert_difference('TaskLike.count') do
      post task_likes_url, params: { task_like: { task_id: @task_like.task_id, user_id: @task_like.user_id } },
                           as: :json
    end

    assert_response 201
  end

  test 'should show task_like' do
    get task_like_url(@task_like), as: :json
    assert_response :success
  end

  test 'should update task_like' do
    patch task_like_url(@task_like),
          params: { task_like: { task_id: @task_like.task_id, user_id: @task_like.user_id } }, as: :json
    assert_response 200
  end

  test 'should destroy task_like' do
    assert_difference('TaskLike.count', -1) do
      delete task_like_url(@task_like), as: :json
    end

    assert_response 204
  end
end
