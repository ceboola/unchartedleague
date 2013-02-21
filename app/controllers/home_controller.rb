class HomeController < ApplicationController
  def index    
    @matches = Match.where('processed = ? and scheduled_at is not ?', true, nil).order('scheduled_at desc').limit(8) # FIXME
    @articles = Article.where('published = ?', true).order('created_at desc').limit(3)
  end
end
