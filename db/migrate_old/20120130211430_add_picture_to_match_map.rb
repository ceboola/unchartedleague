class AddPictureToMatchMap < ActiveRecord::Migration
  def change
    add_column :match_maps, :picture, :string
  end
end
