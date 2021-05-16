# frozen_string_literal: true

require 'test_helper'

class StreaksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @streak = streaks(:one)
  end

  test 'should get index' do
    get streaks_url, as: :json
    assert_response :success
  end

  test 'should create streak' do
    assert_difference('Streak.count') do
      post streaks_url, params: { streak: { user_id: @streak.user_id } }, as: :json
    end

    assert_response 201
  end

  test 'should show streak' do
    get streak_url(@streak), as: :json
    assert_response :success
  end

  test 'should update streak' do
    patch streak_url(@streak), params: { streak: { user_id: @streak.user_id } }, as: :json
    assert_response 200
  end

  test 'should destroy streak' do
    assert_difference('Streak.count', -1) do
      delete streak_url(@streak), as: :json
    end

    assert_response 204
  end
end
