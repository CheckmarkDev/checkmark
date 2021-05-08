class AddMissingForeignKeyProjectToken < ActiveRecord::Migration[6.1]
  def up
    add_foreign_key :projects, :users, column: :user_id
    add_foreign_key :tokens, :users, column: :user_id
    add_foreign_key :projects_tasks, :projects, column: :project_id
    add_foreign_key :projects_tasks, :tasks, column: :task_id
  end

  def down
    remove_foreign_key :projects, :users
    remove_foreign_key :tokens, :users
    remove_foreign_key :projects_tasks, :projects, column: :project_id
    remove_foreign_key :projects_tasks, :tasks, column: :task_id
  end
end
