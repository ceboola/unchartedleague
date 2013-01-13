class CreateCompetitionMaps < ActiveRecord::Migration
  def change
    create_table :competition_maps do |t|
      t.integer :competition_id
      t.integer :map_id

      t.timestamps
    end
  end
end
