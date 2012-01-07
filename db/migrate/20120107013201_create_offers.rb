class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :user
      t.references :team
      t.boolean :originated_from_player
      t.boolean :open
      t.boolean :accepted

      t.timestamps
    end
    add_index :offers, :user_id
    add_index :offers, :team_id
  end
end
