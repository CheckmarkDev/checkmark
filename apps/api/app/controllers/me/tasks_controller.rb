# frozen_string_literal: true

module Me
  class TasksController < ApplicationController
    before_action :authorize_request
    before_action :set_task, only: %i[update destroy]

    api :GET, '/me/tasks'
    def index
      @tasks = Task.includes(:user, :likes).where(user_id: @current_user.id).page(params[:page])
    end

    # GET /tasks/1
    # GET /tasks/1.json
    # def show
    # end

    api :POST, '/me/tasks'
    param :content, String, desc: 'Content of the task'
    param :state, String, desc: 'State'
    def create
      @task = Task.new(task_params)
      @task.source = Task.sources[:checkmark]
      @task.user = @current_user

      if @task.save
        render :show, status: :created
      else
        render json: { errors: @task.errors }, status: :unprocessable_entity
      end
    end

    api :PUT, '/me/tasks/:id'
    param :content, String, desc: 'Content of the task'
    param :state, String, desc: 'State'
    def update
      if task_params[:images].present?
        @task.images.each do |image|
          image.purge unless task_params[:images].include?(image.uuid)
        end

        task_params[:images].each do |image|
          @task.images.attach(image) unless image.is_a? String
        end
      end

      if @task.update(task_params.except(:images))
        render :show, status: :created
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, '/me/tasks/:id'
    def destroy
      @task.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find_by!(uuid: params[:id])

      # rubocop:disable Style/GuardClause
      if @task.user_id != @current_user.id
        render status: :forbidden, json: { error: 'You are not allowed to make this action.' }
        false
      end
      # rubocop:enable Style/GuardClause
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.permit(:content, :state, images: [])
    end
  end
end
