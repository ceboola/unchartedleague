class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.references :author

      t.timestamps
    end
    add_index :articles, :author_id
  end
end
