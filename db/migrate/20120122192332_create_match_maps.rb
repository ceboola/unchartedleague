class CreateMatchMaps < ActiveRecord::Migration
  def change
    create_table :match_maps do |t|
      t.references :match
      t.references :map

      t.timestamps
    end
    add_index :match_maps, :match_id
    add_index :match_maps, :map_id
  end
end
