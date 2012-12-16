class AddViewsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :views, :integer, :after => :image_url
  end
end
