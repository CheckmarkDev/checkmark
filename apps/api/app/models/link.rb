class Link < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, profanity: true, length: { minimum:2, maximum: 255 }
  validates :url, url: { allow_nil: true, no_local: true, public_suffix: true, allow_blank: false }
end
