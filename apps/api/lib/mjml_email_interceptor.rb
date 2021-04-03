class MJMLEmailInterceptor
  def self.delivering_email(message)
    begin
      conn = Faraday.new("http://#{ENV['MJML_HOST']}:#{ENV['MJML_PORT']}", request: {
        open_timeout: 60,
        timeout: 60
      })

      response = conn.post("/", message.html_part.body.to_s, "Content-Type" => "text/plain")

      if response.success?
        message.html_part.body = response.body
      else
        raise Exception.new(JSON.parse(response.body))
      end
    rescue Exception => e
      Raven.captureException(e)
      puts "An error occured while sending e-mail", e

      raise e
    end
  end
end
