require 'test_helper'

class TaskGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_group = task_groups(:one)
  end

  test "should get index" do
    get task_groups_url, as: :json
    assert_response :success
  end

  test "should create task_group" do
    assert_difference('TaskGroup.count') do
      post task_groups_url, params: { task_group: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show task_group" do
    get task_group_url(@task_group), as: :json
    assert_response :success
  end

  test "should update task_group" do
    patch task_group_url(@task_group), params: { task_group: {  } }, as: :json
    assert_response 200
  end

  test "should destroy task_group" do
    assert_difference('TaskGroup.count', -1) do
      delete task_group_url(@task_group), as: :json
    end

    assert_response 204
  end
end
