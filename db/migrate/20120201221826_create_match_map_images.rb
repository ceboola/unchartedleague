class CreateMatchMapImages < ActiveRecord::Migration
  def change
    create_table :match_map_images do |t|
      t.references :match_map
      t.string :url
      t.references :user

      t.timestamps
    end
    add_index :match_map_images, :match_map_id
    add_index :match_map_images, :user_id
  end
end
