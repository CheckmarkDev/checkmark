# frozen_string_literal: true

module Me
  class ProfileController < ApplicationController
    before_action :authorize_request

    api :PUT, '/me/profile'
    def update
      @current_user.assign_attributes(profile_params)

      if profile_params[:avatar].present?
        @current_user.avatar.attach(profile_params[:avatar])
      end

      if @current_user.save!
        @user = @current_user
        render 'authentication/me'
      else
        render json: @current_user.errors, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: e, status: :unprocessable_entity
    end

    private

    def profile_params
      params.permit(:username, :first_name, :last_name, :avatar, :email, :password)
    end
  end
end
