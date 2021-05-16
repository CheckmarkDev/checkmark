# frozen_string_literal: true

class RelationTaskProject < ActiveRecord::Migration[6.1]
  def up
    create_table :projects_tasks, id: false do |t|
      t.belongs_to :project
      t.belongs_to :task
    end
  end

  def down
    drop_table :projects_tasks
  end
end
