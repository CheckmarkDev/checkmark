# frozen_string_literal: true

class WebhookRequest < ApplicationRecord
  belongs_to :webhook

  after_commit :notify_webhook, on: :create

  enum state: {
    pending: 0,
    delivered: 1,
    failed: 2
  }

  private

  def notify_webhook
    WebhookJob.perform_later(webhook, self, data)
  end
end
