class PlayerStats 
  attr_accessor :user, :kills, :assists, :deaths, :maps, :teams, :matches, :competition_activity

  def initialize(user, options = {})
    @user = user
    competition = options[:competition]
    @teams = Team.all_user_teams(user)
    teams_ids = @teams.collect { |x| x.id }
        
    matches_scoped =  Match.where('(team1_id in (?) or team2_id in (?)) and processed = ?', teams_ids, teams_ids, true).scoped
    if !competition.nil?
      matches_scoped = matches_scoped.where('competition_id = ?', competition.id).scoped
    end
    
    team_matches = matches_scoped.all
    
    @kills = 0
    @assists = 0
    @deaths = 0
    @maps = 0    
    @matches = Set.new
    
    for m in team_matches
      if m.has_valid_scores?
        for me in m.match_entries          
          @kills += me.kills
          @deaths += me.deaths
          @assists += me.assists
          @maps += 1
          @matches << m          
        end
      end
    end
    
    @competition_activity = (100.0 * @matches.size / team_matches.size)
  end

  def diff
    @kills - @deaths
  end

  def kdr
    if @deaths > 0
      @kills.to_f / @deaths
    else
      0
    end
  end

  def skill
    if (@deaths > 0 or @kills > 0) and @competition_activity >= 50.0
      100 * ((@kills + 0.65 * @assists) / (@kills + 0.65 * @assists + @deaths))
    else
      0
    end
  end

  def kills_per_map
    if @maps > 0
      @kills.to_f / @maps
    else
      0
    end
  end

  def deaths_per_map
    if @maps > 0
      @deaths.to_f / @maps
    else
      0
    end
  end

  def assists_per_map
    if @maps > 0
      @assists.to_f / @maps
    else
      0
    end
  end
  
  def self.best_match_players(match) # FIXME
    result = {}
    result[:kills] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(kills) desc').sum('kills').first
    result[:assists] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(assists) desc').sum('assists').first
    result[:deaths] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(deaths) asc').sum('deaths').first
    result
  end
end
