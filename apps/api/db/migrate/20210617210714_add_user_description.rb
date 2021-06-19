class AddUserDescription < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :description, :text, null: true, limit: 255
  end

  def down
    remove_column :users, :description
  end
end
