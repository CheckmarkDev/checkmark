# frozen_string_literal: true

class AddTimezoneToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :timezone, :string, default: 'Europe/Paris'
  end

  def down
    remove_column :users, :timezone
  end
end
