# frozen_string_literal: true

module Me
  class EmailNotificationsController < ApplicationController
    before_action :authorize_request
    before_action :set_email_notification, only: %i[index update]

    api :GET, '/me/email_notifications'
    def index
      render :show, status: :ok
    end

    api :PUT, '/me/email_notifications'
    param :like, :boolean, desc: 'Accept to receive e-mail like notifications'
    param :comment, :boolean, desc: 'Accept to receive e-mail comment notifications'
    param :newsletter, :boolean, desc: 'Accept to receive e-mail newsletter notifications'
    def update
      if @email_notification.update(email_notification_params)
        render :show, status: :ok
      else
        render json: @email_notification.errors, status: :unprocessable_entity
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_email_notification
      @email_notification = @current_user.email_notification
    end

    def email_notification_params
      params.permit(:like, :comment, :newsletter)
    end
  end
end
