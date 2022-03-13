# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tasks
  has_many_attached :screenshots
  has_one_attached :avatar
  has_many :webhooks, dependent: :destroy
  has_many :socials, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 32 }, profanity: true
  validates :slug, presence: true, uniqueness: true, length: { minimum: 2, maximum: 32 }, profanity: true
  validates :description, length: { maximum: 255 }, profanity: true
  validates :main_color, presence: true, format: { with: /#(?:[0-9a-fA-F]{3}){1,2}/i }
  validates :url, url: { allow_nil: true, no_local: true, public_suffix: true, allow_blank: false }
  validate :avatar_mime
  validate :screenshots_mime

  before_save :format_slug
  before_create :assign_secret

  def screenshots_mime
    # rubocop:disable Style/GuardClause Layout/LineLength
    if screenshots.attached?
      screenshots.each do |screenshot|
        errors.add(:screenshots, 'Must be a JPG or a PNG') unless screenshot.content_type.in?(%w[image/jpeg image/png])
      end
    end
    # rubocop:enable Style/GuardClause Layout/LineLength
  end

  def avatar_mime
    # rubocop:disable Style/GuardClause
    if avatar.attached? && !avatar.content_type.in?(%w[image/jpeg image/png])
      errors.add(:avatar, 'Must be a JPG or a PNG')
    end
    # rubocop:enable Style/GuardClause
  end

  def avatar_url
    if avatar.attached?
      # rubocop:disable Layout/LineLength
      return Rails.application.routes.url_helpers.url_for(if avatar.variable?
                                                            avatar.variant(
                                                              resize_and_pad: [100, 100,
                                                                               { gravity: 'center', background: '#FFFFFF' }],
                                                              format: :jpg
                                                            )
                                                          else
                                                            avatar
                                                          end)
      # rubocop:enable Layout/LineLength
    end
    ActionController::Base.helpers.image_url('default-avatar.png')
  end

  def assign_secret
    self.github_secret = SecureRandom.hex
  end

  private

  def format_slug
    self.slug = slug.parameterize
  end
end
