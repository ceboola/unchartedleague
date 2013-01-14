class RemoveLogoUrlFromCompetition < ActiveRecord::Migration
  def up
    remove_column :competitions, :logo_url
  end

  def down
    add_column :competitions, :logo_url, :string
  end
end
