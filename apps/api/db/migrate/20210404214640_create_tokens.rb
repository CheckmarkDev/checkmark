class CreateTokens < ActiveRecord::Migration[6.0]
  def up
    create_table :tokens do |t|
      t.uuid :uuid, index: { unique: true }, default: "gen_random_uuid()", null: false
      t.string :token
      t.references :user

      t.timestamps
    end
  end

  def down
    drop_table :tokens
  end
end
