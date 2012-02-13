class AddLockedByJudgeToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :locked_by_judge, :boolean
  end
end
