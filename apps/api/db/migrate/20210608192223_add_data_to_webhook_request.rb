# frozen_string_literal: true

class AddDataToWebhookRequest < ActiveRecord::Migration[6.1]
  def up
    add_column :webhook_requests, :data, :json, null: true
  end

  def down
    remove_column :webhook_requests, :data
  end
end
