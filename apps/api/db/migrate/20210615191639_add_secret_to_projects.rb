# frozen_string_literal: true

class AddSecretToProjects < ActiveRecord::Migration[6.1]
  def up
    add_column :projects, :github_secret, :string, null: true
  end

  def down
    remove_column :projects, :github_secret
  end
end
