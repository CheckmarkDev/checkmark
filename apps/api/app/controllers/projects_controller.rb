# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  api :GET, '/projects/:slug'
  def show
    render 'projects/show'
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:id])
  end
end
