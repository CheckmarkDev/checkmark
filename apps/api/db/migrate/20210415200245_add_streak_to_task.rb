class AddStreakToTask < ActiveRecord::Migration[6.0]
  def up
    add_reference(:tasks, :streak, index: true, null: true)
  end

  def down
    remove_column :streak_id, :tasks
  end
end
