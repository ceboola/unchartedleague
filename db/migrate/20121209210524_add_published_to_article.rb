class AddPublishedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :published, :boolean, :after => :content
  end
end
