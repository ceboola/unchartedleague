class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :competition
      t.integer :number
      t.datetime :starts
      t.datetime :ends

      t.timestamps
    end
    add_index :rounds, :competition_id
  end
end
