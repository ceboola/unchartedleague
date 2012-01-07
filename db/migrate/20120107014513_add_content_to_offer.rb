class AddContentToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :content, :text
  end
end
