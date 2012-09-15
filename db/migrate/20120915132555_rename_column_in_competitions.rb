class RenameColumnInCompetitions < ActiveRecord::Migration
  def up
    rename_column :competitions, :team_stats_type, :team_stats_config
  end

  def down
    rename_column :competitions, :team_stats_config, :team_stats_type
  end
end
