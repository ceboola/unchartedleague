class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.integer :competition_id
      t.integer :importance
      t.integer :user_id
      t.integer :team_id
      t.string :icon_url
      t.string :inline_icon_url

      t.timestamps
    end
  end
end
