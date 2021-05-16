# frozen_string_literal: true

class MakeProjectFieldsNullable < ActiveRecord::Migration[6.1]
  def up
    change_column(:projects, :description, :text, null: true, bulk: true)
    change_column(:projects, :url, :string, null: true, bulk: true)
  end

  def down
    change_column(:projects, :description, :text, null: false, bulk: true)
    change_column(:projects, :url, :string, null: false, bulk: true)
  end
end
