class CreateAchievements < ActiveRecord::Migration[6.1]
  def up
    create_table :achievements do |t|
      t.uuid :uuid, index: { unique: true }, default: 'gen_random_uuid()', null: false
      t.string :code
      t.string :name
      t.text :description

      t.timestamps
    end
  end
  def down
    drop_table :achievements
  end
end
