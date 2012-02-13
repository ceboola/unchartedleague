class CreateMatchMapImages < ActiveRecord::Migration
  def change
    create_table :match_map_images do |t|
      t.references :match_map
      t.string :url
      t.references :user

      t.timestamps
    end
  end
end
