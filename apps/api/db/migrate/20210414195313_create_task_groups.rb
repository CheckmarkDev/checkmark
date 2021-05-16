# frozen_string_literal: true

class CreateTaskGroups < ActiveRecord::Migration[6.0]
  def up
    create_table :task_groups do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.references :user, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end

  def down
    drop_table :task_groups
  end
end
