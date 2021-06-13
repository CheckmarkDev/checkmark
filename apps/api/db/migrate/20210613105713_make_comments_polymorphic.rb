# frozen_string_literal: true

class MakeCommentsPolymorphic < ActiveRecord::Migration[6.1]
  def up
    rename_table(:task_comments, :comments)
    add_reference(:comments, :commentable, polymorphic: true, index: true)

    remove_index(:comments, column: :task_id)
    change_column_null(:comments, :task_id, null: true)
    execute "UPDATE comments SET commentable_id = task_id, commentable_type = 'Task' WHERE id = id"
  end

  def down
    execute 'UPDATE comments SET task_id = commentable_id WHERE id = id'
    remove_reference(:comments, :commentable, polymorphic: true, index: true)
    change_column_null(:comments, :task_id, null: false)
    add_index(:comments, :task_id)
    rename_table(:comments, :task_comments)
  end
end
