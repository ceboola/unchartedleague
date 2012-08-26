class HomeController < ApplicationController
  def index    
    @matches = Match.where('processed = ? and competition_id = ?', true, 12).order('scheduled_at desc').limit(8) # FIXME
  end
end
