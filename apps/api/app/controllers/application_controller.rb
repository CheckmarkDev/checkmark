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
      @decoded_token = JsonWebToken.decode(token)

      raise StandardError, 'Token is invalid' if @decoded_token[:exp].nil? || @decoded_token[:sub].nil?

      raise StandardError, 'Token is expired' if Time.zone.at(@decoded_token[:exp]) < Time.zone.now

      @saved_token = Token.confirmed.find_by(token: token)
      raise StandardError, 'Token is invalid' if @saved_token.nil?

      @current_user = User.includes([
        :streaks,
        { avatar_attachment: :blob }
      ]).where.not(status: User.statuses[:blocked]).find_by!(uuid: @decoded_token[:sub])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue StandardError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  rescue_from Apipie::ParamError do |e|
    render json: { title: e.message }, status: :unprocessable_entity
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
