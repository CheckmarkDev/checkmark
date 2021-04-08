class UserTasksController < ApplicationController
  before_action :set_user, only: [:index]
  before_action :set_task, only: [:show]

  api :GET, '/users/:username/tasks'
  def index
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page])

    render "tasks/index"
  end

  api :GET, '/users/:username/tasks/:uuid'
  def show
    render "tasks/show"
  end

  private
    def set_user
      @user = User.find_by_username!(params[:id])
    end

    def set_task
      @task = Task.find_by_uuid!(params[:id])
    end
end
