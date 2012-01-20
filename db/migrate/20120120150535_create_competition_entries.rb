class CreateCompetitionEntries < ActiveRecord::Migration
  def change
    create_table :competition_entries do |t|
      t.references :competition
      t.references :team

      t.timestamps
    end
    add_index :competition_entries, :competition_id
    add_index :competition_entries, :team_id
  end
end
