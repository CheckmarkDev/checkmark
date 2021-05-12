# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :users do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.string :email, index: { unique: true }, null: false
      t.string :password_digest, null: false
      t.string :username, index: { unique: true }, null: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
