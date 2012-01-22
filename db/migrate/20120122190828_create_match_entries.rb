class CreateMatchEntries < ActiveRecord::Migration
  def change
    create_table :match_entries do |t|
      t.references :match_map
      t.references :user
      t.references :team
      t.integer :score
      t.integer :kills
      t.integer :deaths
      t.integer :assists

      t.timestamps
    end
    add_index :match_entries, :match_id
    add_index :match_entries, :user_id
    add_index :match_entries, :team_id
  end
end
