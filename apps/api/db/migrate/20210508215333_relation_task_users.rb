class RelationTaskUsers < ActiveRecord::Migration[6.1]
  def up
    create_table :mention_tasks_mentions, id: false do |t|
      t.belongs_to :mention_tasks
      t.belongs_to :mentions
    end
    add_foreign_key :mention_tasks_mentions, :mention_tasks, column: :mention_task_id
    add_foreign_key :mention_tasks_mentions, :mentions, column: :mention_id
  end

  def down
    remove_foreign_key :mention_tasks_mentions, :mention_tasks, column: :mention_task_id
    remove_foreign_key :mention_tasks_mentions, :mentions, column: :mention_id
    drop_table :mention_tasks_mentions
  end
end
