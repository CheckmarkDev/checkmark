# frozen_string_literal: true

class AddStatusToUser < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :status, :integer, null: false, default: 0
    add_index :users, :status
  end

  def down
    remove_column :users, :status
    remove_index :users, column: :status
  end
end
