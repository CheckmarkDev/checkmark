# frozen_string_literal: true

class TaskCommentsController < ApplicationController
  before_action :authorize_request, only: %i[create]
  before_action :set_task, only: %i[index create]

  api :GET, '/tasks/:task_uuid/comments'
  def index
    @comments = @task.comments.order(created_at: :desc).page(params[:page])

    render 'comments/index'
  end

  api :POST, '/tasks/:task_uuid/comments'
  def create
    @comment = Comment.new(
      user: @current_user,
      content: comment_params[:content],
      commentable_type: 'Task',
      commentable_id: @task.id
    )

    if @comment.save
      render 'comments/show', status: :created
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # api :PUT, '/tasks/:task_uuid/comments/:comment_uuid'
  # def update
  #   if @comment.update(comment_params)
  #     render json: @comment
  #   else
  #     render json: @comment.errors, status: :unprocessable_entity
  #   end
  # end

  # api :DELETE, '/tasks/:task_uuid/comments/:comment_uuid'
  # def destroy
  #   @comment.destroy
  # end

  private

  def set_task
    @task = Task.find_by!(uuid: params[:task_id])
  end

  def set_comment
    @comment = TaskComment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.permit(:content)
  end
end
