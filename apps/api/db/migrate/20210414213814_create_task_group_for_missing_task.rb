# frozen_string_literal: true

class CreateTaskGroupForMissingTask < ActiveRecord::Migration[6.0]
  def up
    orphan_tasks = Task.where(task_group: nil)
    orphan_tasks.each do |task|
      task_group = TaskGroup.new
      task_group.user = task.user
      task_group.created_at = task.created_at
      task_group.updated_at = task.updated_at

      task.task_group = task_group
      task.save!
    end
  end

  def down; end
end
