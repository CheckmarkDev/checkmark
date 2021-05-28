class AddStatusToToken < ActiveRecord::Migration[6.1]
  def up
    add_column :tokens, :status, :integer, default: 0, null: false
  end

  def down
    remove_column :tokens, :status
  end
end
