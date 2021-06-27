# frozen_string_literal: true

class RemoveDescriptionFromLink < ActiveRecord::Migration[6.1]
  def up
    remove_column :links, :description
  end

  def down
    add_column :links, :description, :string
  end
end
