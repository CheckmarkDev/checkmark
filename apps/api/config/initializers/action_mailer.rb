# frozen_string_literal: true

ActionMailer::Base.register_interceptor(MJMLEmailInterceptor)

Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.asset_host = ENV.fetch('ASSET_HOST', 'http://localhost:3000')
Rails.application.config.action_mailer.default_url_options = ENV.fetch('ASSET_HOST', 'http://localhost:3000')
