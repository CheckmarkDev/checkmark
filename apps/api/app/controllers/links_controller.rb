# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authorize_request, only: %i[create]
  before_action :set_link, only: %i[show]

  # GET /links
  def index
    @links = Link.all.page(params[:page])

    render 'links/index'
  end

  # GET /links/1
  def show
    render 'links/show'
  end

  # POST /links
  def create
    @link = Link.new(link_params)
    @link.user = @current_user

    if @link.save
      render 'links/show'
    else
      render json: { error: @link.errors }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.permit(:url)
  end
end
