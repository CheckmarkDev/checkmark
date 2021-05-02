class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  api :GET, '/projects/:slug'
  def show
    render "projects/show"
  end

  private
    def set_project
      @project = Project.find_by_slug!(params[:id])
    end
end
