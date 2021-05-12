# frozen_string_literal: true

class CreateTaskComments < ActiveRecord::Migration[6.0]
  def up
    create_table :task_comments do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.references :user, null: false, foreign_key: true, index: true
      t.references :task, null: false, foreign_key: true, index: true
      t.text :content

      t.timestamps
    end
  end

  def down
    drop_table :task_comments
  end
end
