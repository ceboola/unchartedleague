class AddForfeitedByToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :forfeiting_team_id, :integer
  end
end
