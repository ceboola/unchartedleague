class AddChallongeModuleUrlToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :challonge_module_url, :string, :before => :created_at
  end
end
