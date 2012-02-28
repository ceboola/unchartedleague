class HomeController < ApplicationController
  def index    
    @matches = Match.where('processed = ?', true).order('scheduled_at desc').limit(5)
  end
end
