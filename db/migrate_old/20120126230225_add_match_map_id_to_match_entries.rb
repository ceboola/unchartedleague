class AddMatchMapIdToMatchEntries < ActiveRecord::Migration
  def change
    add_column :match_entries, :match_map_id, :integer
  end
end
