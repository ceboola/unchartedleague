class MatchMapsController < ApplicationController
  def update
    @match_map = MatchMap.find(params[:id])    
    
    if @match_map.match.can_be_edited_by? current_user
      if params[:match_map][:results_updated_token].present?
        @match_map.update_attributes(params[:match_map].except(:results_updated_token, :match_entries_token, :team_id, :picture_updated_token))

        if params[:match_map].has_key? :team_id
          @team = Team.find(params[:match_map][:team_id])
          max = @match_map.match.competition.max_players_per_team
          max = @team.all_users.size if max > @team.all_users.size
          existing = @match_map.match_entries.select { |x| x.team == @team }.collect { |x| x.user.id }
          @team.all_users.select { |x| not existing.include? x.id }.slice(0...(max - existing.size)).each do |x| 
            @match_map.match_entries.build(:team_id => @team.id, :match_id => @match_map.match.id, :user_id => x.id)
          end
        end    
      end    
    end
  end
end
