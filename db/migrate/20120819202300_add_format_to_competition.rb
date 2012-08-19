class AddFormatToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :format, :string
  end
end
