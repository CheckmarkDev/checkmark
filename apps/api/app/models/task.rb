class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_group, optional: true
  belongs_to :streak, optional: true
  has_many :task_likes
  has_many :task_comments

  enum state: [
    :todo,
    :doing,
    :done
  ]

  before_create :assign_task_group, if: Proc.new { |task| task.task_group.nil? }
  before_create :assign_streak, if: Proc.new { |task| task.streak.nil? }

  def assign_task_group
    timezone = self.user.timezone
    task_group = self.user.task_groups.where(created_at: DateTime.now.in_time_zone(timezone).beginning_of_day..DateTime.now.in_time_zone(timezone).end_of_day).first
    if task_group.nil?
      task_group = TaskGroup.new()
      task_group.user = self.user
      task_group.save!
    end

    self.task_group = task_group
  end

  def assign_streak
    last_streak = self.user.last_streak
    if last_streak.present?
      last_task = last_streak.tasks.order(created_at: :desc).first

      if last_task.created_at.to_datetime.beginning_of_day < DateTime.yesterday
        last_streak = Streak.new
        last_streak.user = self.user
        last_streak.save!
      end
    end

    self.streak = last_streak
  end

end
