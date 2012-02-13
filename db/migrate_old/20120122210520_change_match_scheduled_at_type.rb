class ChangeMatchScheduledAtType < ActiveRecord::Migration
  def up
    change_column :matches, :scheduled_at, :datetime
  end

  def down
    change_column :matches, :scheduled_at, :date
  end
end
