class CreateWebhookRequests < ActiveRecord::Migration[6.1]
  def up
    create_table :webhook_requests do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.integer :state, null: false, default: 0, index: true
      t.string :event, null: false
      t.references :webhook, null: false

      t.timestamps
    end
  end

  def down
    drop_table :webhook_requests
  end
end
