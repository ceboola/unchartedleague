class AddPsnNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :psn_name, :string
  end
end
