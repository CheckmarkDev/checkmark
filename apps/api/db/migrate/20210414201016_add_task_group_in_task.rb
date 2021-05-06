class AddTaskGroupInTask < ActiveRecord::Migration[6.0]
  def up
    add_reference(:tasks, :task_group, index: true, null: true)
  end

  def down
    remove_column :tasks, :task_group_id
  end
end
