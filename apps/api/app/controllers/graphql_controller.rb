# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {}

    # Authorization
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    if token.present?
      begin
        decoded_token = JsonWebToken.decode(token)

        raise StandardError, 'Token is invalid' if decoded_token[:exp].nil? || decoded_token[:sub].nil?

        raise StandardError, 'Token is expired' if Time.zone.at(decoded_token[:exp]) < Time.zone.now

        @saved_token = Token.confirmed.find_by(token: token)
        raise StandardError, 'Token is invalid' if @saved_token.nil?

        context[:current_user] = User.includes([
          :streaks,
          { avatar_attachment: :blob }
        ]).where.not(status: User.statuses[:blocked]).find_by!(uuid: decoded_token[:sub])
      rescue StandardError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end

    result = ApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtracerr.join("\n")

    render json: { errors: [{ message: err.message, backtrace: err.backtrace }], data: {} },
           status: :internal_server_error
  end
end
