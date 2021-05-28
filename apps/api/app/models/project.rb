# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tasks
  has_many_attached :screenshots
  has_one_attached :avatar
  has_many :webhooks, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 32 }, profanity: true
  validates :slug, presence: true, uniqueness: true, length: { minimum: 2, maximum: 32 }, profanity: true
  validates :description, length: { maximum: 255 }, profanity: true
  validates :main_color, presence: true, format: { with: /#(?:[0-9a-fA-F]{3}){1,2}/i }
  validates :url, url: { allow_nil: true, no_local: true, public_suffix: true, allow_blank: false }

  before_save :format_slug

  def avatar_url
    return Rails.application.routes.url_helpers.url_for(avatar.variant(resize_to_fill: [100, 100])) if avatar.attached?

    ActionController::Base.helpers.image_url('default-avatar.png')
  end

  private

  def format_slug
    self.slug = slug.parameterize
  end
end
