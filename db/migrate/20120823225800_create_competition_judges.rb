class CreateCompetitionJudges < ActiveRecord::Migration
  def change
    create_table :competition_judges do |t|
      t.integer :competition_id
      t.integer :user_id

      t.timestamps
    end
  end
end
