class CreateTasks < ActiveRecord::Migration[6.0]
  def up
    create_table :tasks do |t|
      t.uuid :uuid, index: { unique: true }, default: "gen_random_uuid()", null: false
      t.text :content
      t.integer :type, default: 0, null: false
      t.references :user

      t.timestamps
    end
  end

  def down
    drop_table :tasks
  end
end
