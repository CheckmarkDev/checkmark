# frozen_string_literal: true

class MJMLEmailInterceptor
  def self.delivering_email(message)
    request = {
      open_timeout: 60,
      timeout: 60
    }
    conn = Faraday.new("http://#{ENV['MJML_HOST']}:#{ENV['MJML_PORT']}", request: request)

    begin
      response = conn.post('/', message.html_part.body.to_s, 'Content-Type' => 'text/plain')

      message.html_part.body = response.body if response.success?
      raise StandardError, JSON.parse(response.body) unless response.success?
    rescue StandardError => e
      Raven.captureException(e)
      Rails.logger.debug 'An error occured while sending e-mail', e

      raise e
    end
  end
end
