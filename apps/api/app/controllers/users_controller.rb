# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  api :GET, '/users/:username'
  def show; end

  api :POST, '/users/verify_email'
  param :email, String, desc: 'E-mail to verify the existence.', required: true
  def verify_email
    users = User.where(email: user_params[:email]).pluck(:uuid)
    if users.size.zero?
      render json: {}, status: :no_content
    else
      render json: { title: 'E-mail already taken'}, status: :unprocessable_entity
    end
  end

  api :POST, '/users/verify_username'
  param :username, String, desc: 'Username to verify the existence.', required: true
  def verify_username
    users = User.where(username: user_params[:username]).pluck(:uuid)
    if users.size.zero?
      render json: {}, status: :no_content
    else
      render json: { title: 'Username already taken'}, status: :unprocessable_entity
    end
  end

  api :GET, '/users/random'
  def random
    @users = Rails.cache.fetch('random_users', expires_in: 24.hours) do
      users = User
        .where.not(status: User.statuses[:blocked])
        .includes([avatar_attachment: :blob])
        .order('RANDOM()').limit(10)

      data = ApplicationController.render(template: 'users/random', assigns: {
                                            users: users
                                          })

      data
    end

    render json: @users, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.where.not(status: User.statuses[:blocked]).find_by!(username: params[:id])
  end

  def user_params
    params.permit(:email, :username)
  end
end
