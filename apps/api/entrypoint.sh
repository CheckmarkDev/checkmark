#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /back/tmp/pids/server.pid

whenever --update-crontab

service cron restart

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
