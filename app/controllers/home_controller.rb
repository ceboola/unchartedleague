class HomeController < ApplicationController
  def index    
    @marco = Team.joins(:competition_entries).where('competition_entries.competition_id = ?', 3).order('name asc').select('teams.id, tag, name')    
    @polo = Team.joins(:competition_entries).where('competition_entries.competition_id = ?', 4).order('name asc').select('teams.id, tag, name')    
  end
end
