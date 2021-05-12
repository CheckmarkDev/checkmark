# frozen_string_literal: true

class CreateEmailNotifications < ActiveRecord::Migration[6.0]
  def up
    create_table :email_notifications do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.boolean :like, default: true
      t.boolean :comment, default: true
      t.boolean :newsletter, default: true
      t.references :user, null: false, foreign_key: true
    end
  end

  def down
    drop_table :email_notifications
  end
end
