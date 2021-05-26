class AddSecretToWebhook < ActiveRecord::Migration[6.1]
  def up
    add_column :webhooks, :secret, :string, null: true
  end

  def down
    remove_column :webhooks, :secret
  end
end
