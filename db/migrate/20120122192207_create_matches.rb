class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :competition
      t.integer :team1_id
      t.integer :team2_id
      t.date :scheduled_at
      t.integer :judge_id
      t.boolean :processed

      t.timestamps
    end
    add_index :matches, :competition_id
  end
end
