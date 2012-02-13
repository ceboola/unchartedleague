class RemovePictureFromMatchMap < ActiveRecord::Migration
  def up
    remove_column :match_maps, :picture
  end

  def down
    add_column :match_maps, :picture, :string
  end
end
