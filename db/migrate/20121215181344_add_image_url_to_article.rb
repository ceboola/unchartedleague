class AddImageUrlToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :image_url, :string, :after => :published
  end
end
