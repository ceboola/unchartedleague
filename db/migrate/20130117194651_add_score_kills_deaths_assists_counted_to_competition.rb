class AddScoreKillsDeathsAssistsCountedToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :score_counted, :boolean, :default => false
    add_column :competitions, :kills_counted, :boolean, :default => true
    add_column :competitions, :deaths_counted, :boolean, :default => true
    add_column :competitions, :assists_counted, :boolean, :default => true
  end
end
