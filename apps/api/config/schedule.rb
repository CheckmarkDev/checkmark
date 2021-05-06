# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#

ENV.each { |k, v| env(k, v) }

set :output, "/back/log/cron_log.log"
set :environment, ENV['RAILS_ENV']
