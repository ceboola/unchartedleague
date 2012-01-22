class CompetitionsController < ApplicationController
  def index
    @competitions = Competition.all
    @entries = CompetitionEntry.all    
    if user_signed_in? 
      #@signed_up_teams_ids = @entries.collect { |x| x.team.id }
      #@possible_teams = Team.joins(:team_participations).where("team_participations.user_id = ? and team_participations.role = ?", current_user.id, 0)
      #@possible_teams = @possible_teams.select { |x| not @signed_up_teams_ids.include? x.id }
    end
  end
end
