class CreateMissingEmailNotification < ActiveRecord::Migration[6.0]
  def up
    begin
      User.all.each do |user|
        if user.email_notification.nil?
          EmailNotification.create(
            user: user
          )
        end
      end
    rescue => e
      # Do nothing if this migration fails
      puts "Migration failed", e
    end
  end

  def down
  end
end
