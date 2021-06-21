class RemoveTaskFromLikesAndComments < ActiveRecord::Migration[6.1]
  def up
    remove_foreign_key :likes, :tasks
    remove_foreign_key :comments, :tasks

    remove_column :likes, :task_id
    remove_column :comments, :task_id
  end

  def down
    add_column :likes, :task_id, :bigint
    add_column :comments, :task_id, :bigint

    add_foreign_key :likes, :tasks
    add_foreign_key :comments, :tasks
  end
end
