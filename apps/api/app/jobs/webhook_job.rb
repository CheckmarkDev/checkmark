# frozen_string_literal: true

class WebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook, _event, data)
    Faraday.post(webhook.url, data.to_s, 'Content-Type' => 'application/json')
  rescue StandardError => e
    Raven.captureException(e)
    Rails.logger.debug 'An error occured while sending webhook event', e

    raise e
  end
end
