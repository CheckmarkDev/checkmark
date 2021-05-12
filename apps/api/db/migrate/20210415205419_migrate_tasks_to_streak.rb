# frozen_string_literal: true

class MigrateTasksToStreak < ActiveRecord::Migration[6.0]
  def up
    User.all.each do |user|
      streak = Streak.new
      streak.user = user
      streak.save!

      user.tasks.each do |task|
        task.streak = streak
        task.save!
      end
    end
  end

  def down; end
end
