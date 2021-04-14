class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_group, optional: true
  has_many :task_likes
  has_many :task_comments

  enum state: [
    :todo,
    :doing,
    :done
  ]

  before_create :assign_task_group, if: Proc.new { |task| task.task_group.nil? }

  def assign_task_group
    task_group = self.user.task_groups.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).first
    if task_group.nil?
      task_group = TaskGroup.new()
      task_group.user = self.user
      task_group.save!
    end

    self.task_group = task_group
  end

end
