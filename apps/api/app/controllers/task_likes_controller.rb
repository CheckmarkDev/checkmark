class TaskLikesController < ApplicationController
  before_action :set_task, only: [ :index, :create, :update, :destroy ]

  api :GET, '/tasks/:task_uuid/likes'
  def index
    @task_likes = @task.task_likes.includes([
      user: [:streaks, avatar_attachment: :blob]
    ]).order(created_at: :desc).page(params[:page])

    render 'tasks/task_likes/index'
  end

  private
    def set_task
      @task = Task.find_by_uuid!(params[:task_id])
    end
end
