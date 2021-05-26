# frozen_string_literal: true

class AddMainColorToProject < ActiveRecord::Migration[6.1]
  def up
    add_column :projects, :main_color, :string, default: '#2589C7', null: false
  end

  def down
    remove_column :projects, :main_color
  end
end
