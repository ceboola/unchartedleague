class Article < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  
  def html_content
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      :autolink => true, :space_after_headers => true)
      
    markdown.render(content).strip
  end
end
