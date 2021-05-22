# frozen_string_literal: true

module Me
  class ProjectScreenshotsController < ApplicationController
    before_action :authorize_request
    before_action :set_project, only: %i[create destroy]
    before_action :set_screenshot, only: %i[destroy]

    api :POST, '/me/projects/:slug/screenshots'
    def create
      @project.screenshots.attach(screenshot_params[:screenshots])

      if @project.save!
        render 'projects/show'
      else
        render json: { errors: @project.errors }, status: :unprocessable_entity
      end
    end

    api :DELETE, '/me/projects/:slug/screenshots/:uuid'
    def destroy
      @screenshot.purge
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by!(slug: params[:project_id])

      # rubocop:disable Style/GuardClause
      if @project.user_id != @current_user.id
        render status: :forbidden, json: { error: 'You are not allowed to make this action.' }
        false
      end
      # rubocop:enable Style/GuardClause
    end

    def set_screenshot
      @screenshot = @project.screenshots.find_by!(uuid: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def screenshot_params
      params.permit(screenshots: [])
    end
  end
end
