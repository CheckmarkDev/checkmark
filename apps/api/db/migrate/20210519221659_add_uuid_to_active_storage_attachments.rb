# frozen_string_literal: true

class AddUuidToActiveStorageAttachments < ActiveRecord::Migration[6.1]
  def up
    add_column :active_storage_attachments, :uuid, :uuid, default: -> { 'gen_random_uuid()' }, null: false
    add_index :active_storage_attachments, :uuid, unique: true
  end

  def down
    remove_column :active_storage_attachments, :uuid
    remove_index :active_storage_attachments, column: :uuid
  end
end
