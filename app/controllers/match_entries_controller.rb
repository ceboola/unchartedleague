class MatchEntriesController < ApplicationController
  def create
    debugger
    @match = Match.find(params["match"]["id"])
    p_match_maps = params["match"]["match_maps"]
    for match_map in @match.match_maps
      p_match_entries = p_match_maps[match_map.id]
      if p_match_entries.present?
        p_teams = p_match_entries["teams"]
        if p_teams.present?
          for team in @match.teams
            if p_teams[team.id].present?
              p_users = p_teams[team.id]["users"]
                if p_users.present?
                  for user in team.users
                    score = p_users[user.id]
                    if score.present? and score["kills"].present? and score["deaths"].present? and score["assists"].present?
                      match_map.match_entries.build(:match_id => @match.id, :user_id => user.id, :team_id => team.id, :score => score["kills"], :kills => score["kills"], :deaths => score["deaths"], :assists => score["assists"])
                    end
                  end
                end
            end            
          end
        end
      end
    end
    if @match.save
      flash[:success] = t('matches.results_added')
      redirect_to @match
    else
      render :controller => "matches", :action => "show"
    end
  end
end
