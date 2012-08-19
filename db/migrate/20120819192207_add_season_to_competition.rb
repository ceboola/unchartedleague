class AddSeasonToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :season, :integer
  end
end
