class MakeProjectFieldsNullable < ActiveRecord::Migration[6.1]
  def up
    change_column(:projects, :description, :text, null: true)
    change_column(:projects, :url, :string, null: true)
  end

  def down
    change_column(:projects, :description, :text, null: false)
    change_column(:projects, :url, :string, null: false)
  end
end
