class CreateStreaks < ActiveRecord::Migration[6.0]
  def up
    create_table :streaks do |t|
      t.uuid :uuid, index: { unique: true }, default: "gen_random_uuid()", null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :streaks
  end
end
