class Me::ProfileController < ApplicationController
  before_action :authorize_request

  api :PUT, '/me/profile'
  def update
    begin
      @current_user.avatar.attach(profile_params[:avatar])
      @current_user.assign_attributes(profile_params)

      if @current_user.save!
        @user = @current_user
        render "users/show"
      else
        render json: @current_user.errors, status: :unprocessable_entity
      end
    rescue => e
      render json: e, status: :unprocessable_entity
    end
  end

  private
    def profile_params
      params.permit(:username, :first_name, :last_name, :avatar)
    end
end
