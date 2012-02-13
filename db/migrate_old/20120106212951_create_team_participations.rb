class CreateTeamParticipations < ActiveRecord::Migration
  def change
    create_table :team_participations do |t|
      t.integer :team_id
      t.integer :user_id
      t.integer :role

      t.timestamps
    end
  end
end
