# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def up
    create_table :projects do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.string :slug, index: { unique: true }, null: false
      t.string :name
      t.text :description
      t.string :url
      t.references :user, index: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :projects
  end
end
