# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  api :GET, '/users/:username'
  def show; end

  api :GET, '/users/random'
  def random
    @users = Rails.cache.fetch('random_users', expires_in: 24.hours) do
      users = User.where.not(status: User.statuses[:blocked]).includes([avatar_attachment: :blob]).order("RANDOM()").limit(10)

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
end
