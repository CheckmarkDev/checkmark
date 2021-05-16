# frozen_string_literal: true

namespace :task do
  desc 'Assign project to task'
  task assign_project: :environment do
    Task.all.each(&:assign_projects)
  rescue StandardError => e
    Raven.captureMessage("Could not assign project. #{e}")
    Rails.logger.debug "Could not assign project. #{e}"
  end
end
