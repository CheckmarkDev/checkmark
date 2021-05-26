# frozen_string_literal: true

class Webhook < ApplicationRecord
  has_many :webhook_requests, dependent: :destroy

end
