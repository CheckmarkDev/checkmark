# frozen_string_literal: true

class MakeLikesPolymorphic < ActiveRecord::Migration[6.1]
  def up
    rename_table(:task_likes, :likes)
    add_reference(:likes, :likeable, polymorphic: true, index: true)

    remove_index(:likes, column: :task_id)
    change_column_null(:likes, :task_id, null: true)
    execute "UPDATE likes SET likeable_id = task_id, likeable_type = 'Task' WHERE id = id"
  end

  def down
    execute 'UPDATE likes SET task_id = likeable_id WHERE id = id'
    remove_reference(:likes, :likeable, polymorphic: true, index: true)
    change_column_null(:likes, :task_id, null: false)
    add_index(:likes, :task_id)
    rename_table(:likes, :task_likes)
  end
end
