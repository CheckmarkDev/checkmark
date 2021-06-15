class AddSourceToTasks < ActiveRecord::Migration[6.1]
  def up
    add_column :tasks, :source, :integer, null: false, default: 0
    add_index :tasks, :source
  end

  def down
    remove_index :tasks, column: :source
    remove_column :tasks, :source
  end
end
