class AddAdditionalFieldsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :signup_ends, :datetime
    add_column :competitions, :team_stats_type, :string
    add_column :competitions, :player_stats_type, :string
  end
end
