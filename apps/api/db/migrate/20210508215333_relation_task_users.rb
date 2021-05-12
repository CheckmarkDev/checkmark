# frozen_string_literal: true

class RelationTaskUsers < ActiveRecord::Migration[6.1]
  def up
    create_table :task_mentions, id: false do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :task, foreign_key: true
    end
  end

  def down
    drop_table :task_mentions
  end
end
