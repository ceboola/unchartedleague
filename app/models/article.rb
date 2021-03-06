class Article < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  
  validates :title, :presence => true
  validates :content, :presence => true
  validates :author, :presence => true
  
  opinio_subjectum
  
  def html_content
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      :autolink => true, :space_after_headers => true)
      
    markdown.render(content).strip.sub('<ul>', '<ul class="fancy">').html_safe # FIXME
  end
  
  def content_preview
    Nokogiri::HTML.parse(html_content).css('p').first.text
  end
  
  def comment_count
    Comment.where("commentable_type = ? and commentable_id = ?", "Article", id).count
  end
end
