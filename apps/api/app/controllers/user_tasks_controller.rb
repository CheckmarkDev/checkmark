# frozen_string_literal: true

class UserTasksController < ApplicationController
  before_action :set_user, only: [:index]
  before_action :set_task, only: [:show]

  api :GET, '/users/:username/tasks'
  def index
    @tasks = @user.tasks.includes(:user, :task_likes).order(created_at: :desc).page(params[:page])

    render 'tasks/index'
  end

  api :GET, '/users/:username/tasks/:uuid'
  def show
    render 'tasks/show'
  end

  private

  def set_user
    @user = User.validated.find_by!(username: params[:id])
  end

  def set_task
    @task = Task.find_by!(uuid: params[:id])
  end
end
