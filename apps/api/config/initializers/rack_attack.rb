class Rack::Attack
  throttle('request per ip', limit: 100, period: 30.seconds) do |request|
    request.ip
  end

  throttle('limit login & sign-up attempts per email', limit: 30, period: 1.minute) do |req|
    if (req.path == '/auth/login' || req.path == '/auth/register') && req.post?
      # Normalize the email, using the same logic as your authentication process, to
      # protect against rate limit bypasses.
      req.params['email'].to_s.downcase.gsub(/\s+/, '')
    end
  end
end
