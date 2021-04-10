class TasksController < ApplicationController
  before_action :authorize_request, only: [:like, :dislike]
  before_action :set_task, only: [ :show, :like, :dislike ]

  api :GET, '/tasks'
  def index
    @tasks = Task.order(created_at: :desc).page(params[:page])
  end

  api :POST, '/tasks/:uuid/like'
  def like
    @like = TaskLike.where(
      task: @task,
      user: @current_user
    ).first
    if @like.present?
      @like.state = TaskLike.states[:active]
    else
      @like = TaskLike.new(
        task: @task,
        user: @current_user,
        state: TaskLike.states[:active]
      )
    end

    if @like.save
      render :show, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/tasks/:uuid/like'
  def dislike
    @like = TaskLike.where(
      user: @current_user,
      task: @task,
      state: TaskLike.states[:active]
    ).first

    if @like.present?
      @like.update(state: TaskLike.states[:inactive])

      render :show, status: :no_content
    else
      render json: {}, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find_by_uuid!(params[:id])
    end
end
