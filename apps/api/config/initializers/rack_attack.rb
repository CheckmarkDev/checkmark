# frozen_string_literal: true

module Rack
  class Attack
    throttle('request per ip', limit: 100, period: 30.seconds, &:ip)

    throttle('limit login & sign-up attempts per email', limit: 30, period: 1.minute) do |req|
      if (req.path == '/auth/login' || req.path == '/auth/register') && req.post?
        # Normalize the email, using the same logic as your authentication process, to
        # protect against rate limit bypasses.
        req.params['email'].to_s.downcase.gsub(/\s+/, '')
      end
    end

    throttle('limit username & email validation', limit: 20, period: 1.minute) do |req|
      req.ip if (req.path == '/users/verify_email' || req.path == '/users/verify_username') && req.post?
    end
  end
end
