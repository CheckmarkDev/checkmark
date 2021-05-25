# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tasks
  has_many_attached :screenshots
  has_one_attached :avatar

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, length: { minimum: 2, maximum: 32 }
  validates :description, length: { maximum: 255 }
  validates :main_color, presence: true, format: { with: /#(?:[0-9a-fA-F]{3}){1,2}/i }

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
