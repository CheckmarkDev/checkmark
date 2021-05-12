# frozen_string_literal: true

class TaskCommentsController < ApplicationController
  before_action :authorize_request, only: %i[create]
  before_action :set_task, only: %i[index create]

  api :GET, '/tasks/:task_uuid/comments'
  def index
    @task_comments = @task.task_comments.order(created_at: :desc).page(params[:page])

    render 'tasks/task_comments/index'
  end

  api :POST, '/tasks/:task_uuid/comments'
  def create
    @task_comment = TaskComment.new(task_comment_params)
    @task_comment.task = @task
    @task_comment.user = @current_user

    if @task_comment.save!
      render 'tasks/task_comments/show', status: :created
    else
      render json: @task_comment.errors, status: :unprocessable_entity
    end
  end

  # api :PUT, '/tasks/:task_uuid/comments/:comment_uuid'
  # def update
  #   if @task_comment.update(task_comment_params)
  #     render json: @task_comment
  #   else
  #     render json: @task_comment.errors, status: :unprocessable_entity
  #   end
  # end

  # api :DELETE, '/tasks/:task_uuid/comments/:comment_uuid'
  # def destroy
  #   @task_comment.destroy
  # end

  private

  def set_task
    @task = Task.find_by!(uuid: params[:task_id])
  end

  def set_task_comment
    @task_comment = TaskComment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_comment_params
    params.permit(:content)
  end
end
