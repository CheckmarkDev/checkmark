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

      if @decoded[:exp].nil? || @decoded[:sub].nil?
        raise Exception.new 'Token is invalid'
      end

      if Time.at(@decoded[:exp]) < Time.now
        raise Exception.new 'Token is expired'
      end

      saved_token = Token.find_by(token: token)
      if saved_token.nil?
        raise Exception.new 'Token is invalid'
      end

      @current_user = User.find_by_uuid(@decoded[:sub])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue Exception => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  private

    def set_raven_context
      Raven.user_context(id: session[:current_user_id]) # or anything else in session
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
end
