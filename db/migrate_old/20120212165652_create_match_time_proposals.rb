class CreateMatchTimeProposals < ActiveRecord::Migration
  def change
    create_table :match_time_proposals do |t|
      t.references :match
      t.references :team
      t.datetime :proposal

      t.timestamps
    end
    add_index :match_time_proposals, :match_id
    add_index :match_time_proposals, :team_id
  end
end
