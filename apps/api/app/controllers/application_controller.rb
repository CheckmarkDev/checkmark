# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_raven_context

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    if token.nil?
      render json: { errors: 'Authorization header is not present' }, status: :unauthorized
      return
    end

    begin
      @decoded = JsonWebToken.decode(token)

      raise StandardError, 'Token is invalid' if @decoded[:exp].nil? || @decoded[:sub].nil?

      raise StandardError, 'Token is expired' if Time.zone.at(@decoded[:exp]) < Time.zone.now

      saved_token = Token.find_by(token: token)
      raise StandardError, 'Token is invalid' if saved_token.nil?

      @current_user = User.includes([
        :streaks,
        { avatar_attachment: :blob }
      ]).validated.find_by!(uuid: @decoded[:sub])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue StandardError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
