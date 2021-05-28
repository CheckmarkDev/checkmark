# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: %i[login register]

  api :GET, '/auth/me'
  def me
    render status: :ok
  end

  api :POST, '/auth/login'
  param :email, String, desc: 'E-mail'
  param :password, String, desc: 'Password'
  def login
    @user = User.where.not(status: User.statuses[:blocked]).includes(:projects).find_by(email: login_params[:email])
    if @user.nil?
      render json: { errors: 'unauthorized' }, status: :unauthorized
      return false
    end

    if @user.authenticate(login_params[:password])
      generate_token(@user)

      render status: :ok
    else
      render json: { errors: 'unauthorized' }, status: :unauthorized
    end
  end

  api :POST, '/auth/register'
  param :email, String, desc: 'E-mail'
  param :password, String, desc: 'Password'
  param :username, String, desc: 'username'
  param :first_name, String, desc: 'first_name'
  param :last_name, String, desc: 'last_name'
  def register
    render json: {}, status: :unauthorized
    # @user = User.includes(:projects).find_by(email: register_params[:email])
    # unless @user.nil?
    #   render json: { errors: 'An account with this e-mail already exists' }, status: :unauthorized
    #   return false
    # end

    # @user = User.new(
    #   email: register_params[:email],
    #   password: register_params[:password],
    #   username: register_params[:username],
    #   first_name: register_params[:first_name],
    #   last_name: register_params[:last_name]
    # )

    # if @user.save!
    #   generate_token(@user)

    #   render status: :created
    # else
    #   render json: {}, status: :unprocessable_entity
    # end
  end

  api :POST, '/auth/email_validation'
  def email_validation
    if @decoded_token[:type] != 'email_validation'
      return render json: { errors: 'Token is invalid' }, status: :unauthorized
    end

    @current_user.status = User.statuses[:validated]
    @saved_token.update!(
      status: Token.statuses[:revoked]
    )

    if @current_user.save!
      render json: {}, status: :created
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  # def password_forgot
  #   @user = User.find_by_email(password_forgot_params[:email])
  #   if !@user.nil?
  #     generate_token(@user)

  #     UserMailer.password_forgot(@user, @token).deliver_later
  #   end

  #   render json: {}, status: :ok
  # end

  # def password_reset
  #   if password_reset_params[:password] != password_reset_params[:password_confirmation]
  #     render json: {
  #       error: 'Both passwords do not match'
  #     }, status: :bad_request
  #   else
  #     if @current_user.update(password: password_reset_params[:password])
  #       render status: :ok
  #     else
  #       render json: {}, status: :unprocessable_entity
  #     end
  #   end
  # end

  private

  def generate_token(user)
    timezone = user.timezone
    @expires_at = (DateTime.now.in_time_zone(timezone) + 1.month).to_i
    @token = JsonWebToken.encode(
      sub: user.uuid,
      type: 'auth',
      exp: @expires_at
    )

    Token.create!(
      token: @token,
      user: user,
      ip: request.remote_ip || nil
    )
  end

  def password_reset_params
    params.permit(:password, :password_confirmation)
  end

  def password_forgot_params
    params.permit(:email)
  end

  def login_params
    params.permit(:email, :password)
  end

  def register_params
    params.permit(:email, :password, :username, :first_name, :last_name)
  end
end
