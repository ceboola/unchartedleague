class UpdateCompetitions < ActiveRecord::Migration
  def up
    remove_column :competitions, :format
    change_column :competitions, :team_stats_type, :text
    remove_column :competitions, :player_stats_type
  end

  def down
    add_column :competitions, :format, :string
    change_column :competitions, :team_stats_type, :string
    add_column :competitions, :player_stats_type, :string
  end
end
