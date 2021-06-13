# frozen_string_literal: true

class TaskLikesController < ApplicationController
  before_action :set_task, only: %i[index]

  api :GET, '/tasks/:task_uuid/likes'
  def index
    @likes = @task.likes.includes([
                                              user: [:streaks, { avatar_attachment: :blob }]
                                            ]).order(created_at: :desc).page(params[:page])

    render 'likes/index'
  end

  private

  def set_task
    @task = Task.find_by!(uuid: params[:task_id])
  end
end
