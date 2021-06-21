# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authorize_request, only: %i[like dislike]
  before_action :set_task, only: %i[like dislike]

  api :GET, '/tasks'
  def index
    @tasks = Task.includes(:likes, :user).order(created_at: :desc).page(params[:page])
  end

  api :POST, '/tasks/:uuid/like'
  def like
    @like = @task.likes.where(
      user: @current_user
    ).first
    if @like.present?
      @like.state = Like.states[:active]
    else
      if @task.user == @current_user
        return render json: {
          error: 'Not allowed to like your own task.'
        }, status: :forbidden
      end

      @like = @task.likes.new(
        user: @current_user,
        state: Like.states[:active]
      )
    end

    if @like.save!
      Rails.cache.write([@task, :likes], @task.user_likes)

      render :show, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/tasks/:uuid/like'
  def dislike
    @like = @task.likes.where(
      user: @current_user,
      state: Like.states[:active]
    ).first

    if @like.present?
      @like.update(state: Like.states[:inactive])

      Rails.cache.write([@task, :likes], @task.user_likes)

      render :show, status: :no_content
    else
      render json: {}, status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find_by!(uuid: params[:id])
  end
end
