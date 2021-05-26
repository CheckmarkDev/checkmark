# frozen_string_literal: true

require 'securerandom'

class Webhook < ApplicationRecord
  has_many :webhook_requests, dependent: :destroy
  belongs_to :user, required: false
  belongs_to :project, required: false

  before_create :assign_secret

  private

  def assign_secret
    self.secret = SecureRandom.hex
  end

end
