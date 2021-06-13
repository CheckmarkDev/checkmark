# frozen_string_literal: true

module Me
  class WebhooksController < ApplicationController
    before_action :authorize_request
    before_action :set_webhook, only: %i[destroy]

    api :GET, '/me/webhooks'
    def index
      @webhooks = @current_user.webhooks.page(params[:page])

      render 'webhooks/index'
    end

    api :POST, '/me/webhooks'
    def create
      @webhook = Webhook.new(webhook_params)
      @webhook.user = @current_user

      if @webhook.save
        render 'webhooks/show'
      else
        render json: { errors: @webhook.errors }, status: :unprocessable_entity
      end
    end

    api :DELETE, '/me/webhooks/:uuid'
    def destroy
      @webhook.destroy!
    end

    private

    def set_webhook
      @webhook = @current_user.webhooks.find_by!(uuid: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def webhook_params
      params.permit(:url)
    end
  end
end
