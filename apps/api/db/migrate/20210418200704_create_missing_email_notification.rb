# frozen_string_literal: true

class CreateMissingEmailNotification < ActiveRecord::Migration[6.0]
  def up
    User.all.each do |user|
      next unless user.email_notification.nil?

      EmailNotification.create(
        user: user
      )
    end
  rescue StandardError => e
    # Do nothing if this migration fails
    Rails.logger.debug 'Migration failed', e
  end

  def down; end
end
