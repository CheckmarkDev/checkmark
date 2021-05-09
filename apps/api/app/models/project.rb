class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tasks
  has_many_attached :screenshots
  has_one_attached :avatar

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, length: { minimum: 2, maximum: 32 }
  validates :description,length: { maximum: 255 }

  before_save :format_slug

  def avatar_url
    if self.avatar.attached?
      return Rails.application.routes.url_helpers.url_for(self.avatar.variant(resize_to_fill: [100, 100]))
    end

    return ActionController::Base.helpers.image_url('default-avatar.png')
  end

  private
    def format_slug
      self.slug = self.slug.parameterize
    end
end
