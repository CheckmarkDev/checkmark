class WebhookJob < ApplicationJob
  queue_as :default

  def perform (webhook, event, data)
    begin
      Faraday.post(webhook.url, data.to_s, "Content-Type" => "application/json")
    rescue Exception => e
      Raven.captureException(e)
      puts "An error occured while sending webhook event", e

      raise e
    end
  end
end
