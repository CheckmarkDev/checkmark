class Me::ProfileController < ApplicationController
  before_action :authorize_request

  api :PUT, '/me/profile'
  def update
    begin
      @current_user.avatar.attach(profile_params[:avatar])
      if @current_user.save!
        render json: {}, status: :ok
      else
        render json: @current_user.errors, status: :unprocessable_entity
      end
    rescue => e
      render json: e, status: :unprocessable_entity
    end
  end

  private
    def profile_params
      params.permit(:avatar)
    end
end
