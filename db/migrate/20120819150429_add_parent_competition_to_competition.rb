class AddParentCompetitionToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :parent_competition_id, :integer
  end
end
