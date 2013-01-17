class AddScoreBaseToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :score_base, :string, :default => "kills"
  end
end
