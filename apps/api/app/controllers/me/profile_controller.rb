# frozen_string_literal: true

module Me
  class ProfileController < ApplicationController
    before_action :authorize_request

    api :PUT, '/me/profile'
    def update
      @current_user.assign_attributes(profile_params)

      @current_user.avatar.attach(profile_params[:avatar]) if profile_params[:avatar].present?

      if @current_user.save!
        @user = @current_user
        render 'authentication/me'
      else
        render json: { errors: @current_user.errors }, status: :unprocessable_entity
      end
    rescue StandardError
      render json: {
        errors: @current_user.errors
      }, status: :unprocessable_entity
    end

    private

    def profile_params
      params.permit(:username, :first_name, :last_name, :avatar, :email, :password)
    end
  end
end
