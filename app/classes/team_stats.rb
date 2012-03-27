class TeamStats
  attr_accessor :team, :matches, :maps, :wins, :losses, :points, :frags_diff, :frags_for, :frags_against, :assists
  
  def initialize(team, competition)
    @team = team
    matches = Match.where('(team1_id = ? or team2_id = ?) and competition_id = ? and processed = ?', team.id, team.id, competition.id, true)
    @matches = matches.size    
    @maps = 0
    @wins = 0
    @losses = 0
    @points = 0
    @frags_for = 0
    @frags_against = 0
    @assists = 0
    for m in matches      
      team1wins = 0
      team2wins = 0
      team1frags = 0
      team2frags = 0
      if m.forfeiting_team.nil?
        for match_map in m.match_maps
          if match_map.match_entries.any?
            @maps += 1
            if match_map.winning_team == m.team1
              team1wins += 1
            elsif match_map.winning_team == m.team2
              team2wins += 1
            end
            team1frags += match_map.team1score
            team2frags += match_map.team2score
          end
        end
      else
        @maps += 2
        if m.forfeiting_team == m.team1
          team2wins = 2
          team2frags = 50
        else
          team1wins = 2
          team1frags = 50
        end
      end
      if team1wins > team2wins
        if m.team1 == team
          @points += 3
          @wins += 1
        elsif team2wins > 0
          @points += 1        
          @losses += 1
        else
          @losses += 1
        end
      else
        if m.team2 == team
          @points += 3
          @wins += 1
        elsif team1wins > 0
          @points += 1        
          @losses += 1
        else
          @losses += 1
        end
      end
      
      if m.team1 == team
        @frags_for += team1frags
        @frags_against += team2frags
      else
        @frags_for += team2frags
        @frags_against += team1frags
      end
    end
    @frags_diff = @frags_for - @frags_against
    # @assists = Match.joins(:match_maps).joins(:match_entries).where('team_id = ? and competition_id = ? and processed = ?', team.id, competition.id, true).sum('assists')
  end
end
