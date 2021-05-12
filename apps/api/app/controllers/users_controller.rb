# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  api :GET, '/users/:username'
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by!(username: params[:id])
  end
end
