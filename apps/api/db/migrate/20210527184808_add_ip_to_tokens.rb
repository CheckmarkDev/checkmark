# frozen_string_literal: true

class AddIpToTokens < ActiveRecord::Migration[6.1]
  def up
    add_column :tokens, :ip, :string, null: true
  end

  def down
    remove_column :tokens, :ip
  end
end
