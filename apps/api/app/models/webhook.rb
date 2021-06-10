# frozen_string_literal: true

require 'securerandom'

class Webhook < ApplicationRecord
  has_many :webhook_requests, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :project, optional: true

  before_create :assign_secret

  validates :url, url: {
    allow_nil: true,
    no_local: Rails.env.production?,
    public_suffix: Rails.env.production?,
    allow_blank: false
  }

  private

  def assign_secret
    self.secret = SecureRandom.hex
  end
end
