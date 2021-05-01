class CreateProjects < ActiveRecord::Migration[6.0]
  def up
    create_table :projects do |t|
      t.uuid :uuid, index: { unique: true }, default: "gen_random_uuid()", null: false
      t.string :slug, index: { unique: true }, null: false
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end

    add_reference(:projects, :user, index: true, null: false)
  end

  def down
    drop_table :projects
    remove_column :projects, :user_id
  end
end
