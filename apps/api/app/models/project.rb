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
  validate :avatar_mime
  validate :screenshots_mime

  before_save :format_slug

  def screenshots_mime
    if screenshots.attached?
      screenshots.each do |screenshot|
        if !screenshot.content_type.in?(%w(image/jpeg image/png))
          errors.add(:screenshots, 'Must be a JPG or a PNG')
        end
      end
    end
  end

  def avatar_mime
    if avatar.attached? && !avatar.content_type.in?(%w(image/jpeg image/png))
      errors.add(:avatar, 'Must be a JPG or a PNG')
    end
  end

  def avatar_url
    return Rails.application.routes.url_helpers.url_for(avatar.variable? ? avatar.variant(
        resize_and_pad: [100, 100, gravity: 'center', background: '#FFFFFF'],
        format: :jpg
      ) : avatar
    ) if avatar.attached?

    ActionController::Base.helpers.image_url('default-avatar.png')
  end

  private

  def format_slug
    self.slug = slug.parameterize
  end
end
