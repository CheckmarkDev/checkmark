class SetUserIdAsNonNullable < ActiveRecord::Migration[6.1]
  def up
    change_column :tasks, :user_id, :bigint, foreign_key: true, null: false
    change_column :tokens, :user_id, :bigint, foreign_key: true, null: false
  end

  def down
    change_column :tasks, :user_id, :bigint, foreign_key: true, null: true
    change_column :tokens, :user_id, :bigint, foreign_key: true, null: true
  end
end
