class MakeTaskGroupNonNullable < ActiveRecord::Migration[6.0]
  def up
    change_column(:tasks, :task_group_id, :integer, null: false)
  end

  def down
    change_column(:tasks, :task_group_id, :integer, null: true)
  end
end
