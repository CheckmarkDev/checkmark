class AuthenticationController < ApplicationController
  before_action :authorize_request, except: [:login, :register, :password_forgot]

  def me
    render status: :ok
  end

  def login
    @user = User.find_by_email(login_params[:email])
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

  def register
    @user = User.find_by_email(register_params[:email])
    if !@user.nil?
      render json: { errors: 'An account with this e-mail already exists' }, status: :unauthorized
      return false
    end

    @user = User.new(
      email: register_params[:email],
      password: register_params[:password],
    )

    if @user.save
      generate_token(@user)

      render status: :created
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
    @expires_at = (DateTime.now + 1.month).to_i
    @token = JsonWebToken.encode(
      sub: user.uuid,
      exp: @expires_at
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
    params.permit(:email, :password)
  end
end
