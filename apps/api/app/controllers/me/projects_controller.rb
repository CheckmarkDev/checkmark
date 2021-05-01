class Me::ProjectsController < ApplicationController
  before_action :authorize_request
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  api :GET, '/me/projects'
  def index
    @projects = @current_user.projects

    render json: @projects
  end

  # GET /projects/1
  api :GET, '/me/projects/:id'
  def show
    render json: @project
  end

  # POST /projects
  api :POST, '/me/projects'
  def create
    @project = Project.new(project_params)
    @project.user = @current_user

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  api :PUT, '/me/projects/:id'
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  api :DELETE, '/me/projects/:id'
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by_uuid!(params[:id])

      if @project.user_id != @current_user.id
        render status: :forbidden, json: { error: 'You are not allowed to make this action.' }
        return false
      end
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:slug, :name, :description, :url)
    end
end
