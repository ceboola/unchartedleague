class AddRegulationsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :regulations, :text
  end
end
