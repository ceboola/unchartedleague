class AddStartsEndsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :starts, :datetime
    add_column :competitions, :ends, :datetime
  end
end
