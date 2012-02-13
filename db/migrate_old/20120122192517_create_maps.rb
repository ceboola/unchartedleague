class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name
      t.references :competition
      t.string :image_url

      t.timestamps
    end
    add_index :maps, :competition_id
  end
end
