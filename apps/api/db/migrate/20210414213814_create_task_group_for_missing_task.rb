class CreateTaskGroupForMissingTask < ActiveRecord::Migration[6.0]
  def up
    orphanTasks = Task.where(task_group: nil)
    orphanTasks.each do |task|
      taskGroup = TaskGroup.new
      taskGroup.user = task.user
      taskGroup.created_at = task.created_at
      taskGroup.updated_at = task.updated_at

      task.task_group = taskGroup
      task.save!
    end
  end

  def down
  end
end
