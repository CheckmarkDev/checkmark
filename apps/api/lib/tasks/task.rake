namespace :task do
  desc "Assign project to task"
  task assign_project: :environment do
    begin
      Task.all.each do |task|
        task.assign_projects
      end
    rescue => e
      Raven.captureMessage("Could not assign project. #{e}")
      puts "Could not assign project. #{e}"
    end
  end
end
