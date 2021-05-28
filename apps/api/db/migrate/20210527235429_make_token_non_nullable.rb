class MakeTokenNonNullable < ActiveRecord::Migration[6.1]
  def up
    change_column :tokens, :token, :string, null: false
    add_index :tokens, :token, unique: true
  end

  def down
    change_column :tokens, :token, :string, null: true
    remove_index :tokens, column: :token
  end
end
