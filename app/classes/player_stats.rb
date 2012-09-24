class PlayerStats 
  attr_accessor :user, :kills, :assists, :deaths, :maps, :teams, :matches, :activity, :debug

  def initialize(user)
    @user = user
    @kills = 0
    @assists = 0
    @deaths = 0
    @maps = 0    
    @teams = Array.new
    @matches_for_teams = {}
    @matches = 0
  end
  
  def add_match_entry me
    @kills += me.kills
    @deaths += me.deaths
    @assists += me.assists
    @maps += 1    
    unless @teams.include? me.team
      @teams << me.team       
    end
    unless @matches_for_teams.has_key? me.team
      @matches_for_teams[me.team] = Array.new
    end
    
    unless @matches_for_teams[me.team].include? me.match_map.match
      @matches_for_teams[me.team] << me.match_map.match
      @matches += 1
    end
  end
  
  def calculate_activity team_matches # FIXME: hide this logic (player stats need to be covered by some kind of team stats)    
    @activity = 0    
    for team in @teams
      if team_matches.has_key? team and team_matches[team] > 0
        temp_activity = (100.0 * @matches_for_teams[team].size / team_matches[team])        
        @activity = temp_activity if temp_activity > @activity        
      end
    end
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
    if (@deaths > 0 or @kills > 0) and @activity >= 50.0
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
