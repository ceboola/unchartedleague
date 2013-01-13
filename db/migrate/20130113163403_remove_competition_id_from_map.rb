class RemoveCompetitionIdFromMap < ActiveRecord::Migration
  def up
    remove_column :maps, :competition_id
  end

  def down
    add_column :maps, :competition_id, :integer
  end
end
