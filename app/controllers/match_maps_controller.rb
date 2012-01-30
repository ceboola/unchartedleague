class MatchMapsController < ApplicationController
  def update
    @match_map = MatchMap.find(params[:id])    
    @match_map.update_attributes(params[:match_map].except(:results_updated_token, :match_entries_token, :team_id))

    @team = Team.find(params[:match_map][:team_id])
    max = @match_map.match.competition.max_players_per_team
    max = @team.users.size if max > @team.users.size
    existing = @match_map.match_entries.select { |x| x.team == @team }.collect { |x| x.user.id }
    @team.users.select { |x| not existing.include? x.id }.slice(0...(max - existing.size)).each do |x| 
      @match_map.match_entries.build(:team_id => @team.id, :match_id => @match_map.match.id, :user_id => x.id)
    end
  end
end
