class AddRoundNameToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :round_name, :string, :after => :number
  end
end
