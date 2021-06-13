# frozen_string_literal: true

class WebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook, webhook_request, data)
    response = Faraday.post(webhook.url, data.to_s, 'Content-Type' => 'application/json')
    if response.status >= 200 && response.status < 299
      webhook_request.update(
        state: WebhookRequest.states[:delivered]
      )
    else
      webhook_request.update(
        state: WebhookRequest.states[:failed]
      )
    end
  rescue StandardError => e
    webhook_request.update(
      state: WebhookRequest.states[:failed]
    )

    Raven.captureException(e)

    raise e
  end
end
