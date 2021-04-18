class WebhookJob < ApplicationJob
  queue_as :default

  def perform (webhook, event, data)
    begin
      conn = Faraday.new(webhook.url, request: {
        open_timeout: 60,
        timeout: 60
      })

      conn.post("/", data.to_s, "Content-Type" => "application/json")
    rescue Exception => e
      Raven.captureException(e)
      puts "An error occured while sending webhook event", e

      raise e
    end
  end
end
