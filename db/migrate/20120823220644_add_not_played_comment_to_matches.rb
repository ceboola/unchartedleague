class AddNotPlayedCommentToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :not_played_comment, :string
  end
end
