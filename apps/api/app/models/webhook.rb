# frozen_string_literal: true

require 'securerandom'

class Webhook < ApplicationRecord
  has_many :webhook_requests, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :project, optional: true

  before_create :assign_secret

  private

  def assign_secret
    self.secret = SecureRandom.hex
  end
end
