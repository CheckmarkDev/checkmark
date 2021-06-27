# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[6.1]
  def up
    create_table :links do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :description
      t.string :url, null: false

      t.timestamps
    end
  end

  def down
    drop_table :links
  end
end
