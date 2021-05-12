# frozen_string_literal: true

class AddMissingForeignKeyProjectToken < ActiveRecord::Migration[6.1]
  def up
    add_foreign_key :projects, :users, column: :user_id
    add_foreign_key :tokens, :users, column: :user_id
    add_foreign_key :projects_tasks, :projects, column: :project_id
    add_foreign_key :projects_tasks, :tasks, column: :task_id
    add_foreign_key :tasks, :streaks, column: :streak_id
    add_foreign_key :tasks, :users, column: :user_id
    add_foreign_key :tasks, :task_groups, column: :task_group_id
  end

  def down
    remove_foreign_key :projects, :users
    remove_foreign_key :tokens, :users
    remove_foreign_key :projects_tasks, :projects, column: :project_id
    remove_foreign_key :projects_tasks, :tasks, column: :task_id
    remove_foreign_key :tasks, :streaks
    remove_foreign_key :tasks, :users
    remove_foreign_key :tasks, :task_groups
  end
end
