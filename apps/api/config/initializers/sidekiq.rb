Sidekiq.configure_server do |config|
  pool_size = Sidekiq.options[:concurrency] + 2

  config.redis = { :url => ENV.fetch('REDIS_URL'), :size => pool_size }
end
