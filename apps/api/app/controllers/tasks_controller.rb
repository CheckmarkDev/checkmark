class TasksController < ApplicationController
  before_action :set_task, only: %i[ show ]

  api :GET, '/tasks'
  def index
    @tasks = Task.order(created_at: :desc).page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find_by_uuid(params[:id])
    end
end
