class AddActiveToMatchTimeProposal < ActiveRecord::Migration
  def change
    add_column :match_time_proposals, :active, :boolean
  end
end
