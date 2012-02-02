class AddActiveToTeamParticipation < ActiveRecord::Migration
  def change
    add_column :team_participations, :active, :boolean
  end
end
