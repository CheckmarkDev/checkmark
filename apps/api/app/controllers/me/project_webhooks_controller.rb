# frozen_string_literal: true

module Me
  class ProjectWebhooksController < ApplicationController
    before_action :authorize_request
    before_action :set_project, only: %i[create index destroy]
    before_action :set_webhook, only: %i[destroy]

    api :GET, '/me/projects/:slug/webhooks'
    def index
      @webhooks = @project.webhooks

      render 'projects/show'
    end

    api :POST, '/me/projects/:slug/webhooks'
    def create
      @webhook = Webhook.new(webhook_params)
      @webhook.project = @project

      if @webhook.save!
        render 'projects/show'
      else
        render json: { errors: @project.errors }, status: :unprocessable_entity
      end
    end

    api :DELETE, '/me/projects/:slug/webhooks/:uuid'
    def destroy
      @webhook.destroy!
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

    def set_webhook
      @webhook = @project.webhooks.find_by!(uuid: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def webhook_params
      params.permit(:url)
    end
  end
end
