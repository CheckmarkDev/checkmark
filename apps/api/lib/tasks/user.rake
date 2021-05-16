# frozen_string_literal: true

namespace :user do
  desc 'Notify for weekly summary'
  task weekly_summary: :environment do
    Rails.logger.debug 'Notify for weekly summary'
    begin
      User.notify_weekly_summary
    rescue StandardError => e
      Raven.captureMessage("Could not notify weekly summary. #{e}")
      Rails.logger.debug "Could not notify weekly summary. #{e}"
    end
  end

  desc 'Notify for streak'
  task streak_reminder: :environment do
    Rails.logger.debug 'Notify for streak'
    begin
      User.notify_streak_reminder
    rescue StandardError => e
      Raven.captureMessage("Could not notify streak. #{e}")
      Rails.logger.debug "Could not notify streak. #{e}"
    end
  end
end
