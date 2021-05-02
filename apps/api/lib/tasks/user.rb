namespace :user do
  desc "Notify for weekly summary"
  task weekly_summary: :environment do
    puts "Notify for weekly summary"
    begin
      User.notify_weekly_summary
    rescue => e
      Raven.captureMessage("Could not notify weekly summary. #{e}")
      puts "Could not notify weekly summary. #{e}"
    end
  end
end
