# frozen_string_literal: true

module Me
  class ProjectsController < ApplicationController
    before_action :authorize_request
    before_action :set_project, only: %i[show update destroy github]

    # GET /projects
    api :GET, '/me/projects'
    def index
      @projects = @current_user.projects

      render json: @projects
    end

    # GET /projects/1
    api :GET, '/me/projects/:id'
    def show
      render 'projects/show'
    end

    # GET /projects/1
    api :GET, '/me/projects/:id/github'
    def github
      render json: {
        secret: @project.github_secret
      }, status: :ok
    end

    # POST /projects
    api :POST, '/me/projects'
    param :slug, String, desc: 'Slug of the project'
    param :name, String, desc: 'Name of the project'
    param :description, String, desc: 'Description of the project'
    param :main_color, String, desc: 'Main color of the project'
    param :url, String, desc: 'Url of the project'
    def create
      @project = Project.new(project_params)
      @project.user = @current_user

      if @project.save
        render 'projects/show'
      else
        render json: { errors: @project.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /projects/1
    api :PUT, '/me/projects/:id'
    def update
      @project.assign_attributes(project_params)

      @project.avatar.attach(project_params[:avatar]) if project_params[:avatar].present?

      if @project.save
        render 'projects/show'
      else
        render json: { errors: @project.errors }, status: :unprocessable_entity
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
      @project = Project.find_by!(slug: params[:id])

      # rubocop:disable Style/GuardClause
      if @project.user_id != @current_user.id
        render status: :forbidden, json: { error: 'You are not allowed to make this action.' }
        false
      end
      # rubocop:enable Style/GuardClause
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.permit(:slug, :name, :description, :url, :main_color, :avatar)
    end
  end
end
