class TaskGroupsController < ApplicationController

  api :GET, '/task_groups'
  def index
    @task_groups = TaskGroup.includes(:tasks, :user).order(created_at: :desc).page(params[:page])

    render 'task_groups/index'
  end
end
