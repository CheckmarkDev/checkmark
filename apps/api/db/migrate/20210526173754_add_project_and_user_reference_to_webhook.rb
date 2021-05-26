# frozen_string_literal: true

class AddProjectAndUserReferenceToWebhook < ActiveRecord::Migration[6.1]
  def up
    add_reference(:webhooks, :user, index: true, null: true, foreign_key: true)
    add_reference(:webhooks, :project, index: true, null: true, foreign_key: true)
  end

  def down
    remove_column :webhooks, :user_id
    remove_column :webhooks, :project_id
  end
end
