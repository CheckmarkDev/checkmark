class CreateSocials < ActiveRecord::Migration[6.1]
  def up
    create_table :socials do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.string :name, index: { unique: true }, null: false
      t.string :title
      t.string :url, null: false

      t.timestamps
    end
  end

  def down
    drop_table :socials
  end
end
