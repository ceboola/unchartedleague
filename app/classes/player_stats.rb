class PlayerStats 
  attr_accessor :user, :kills, :assists, :deaths, :maps, :team, :matches, :competition_activity

  def initialize(user, team)
    @user = user
    @kills = 0
    @assists = 0
    @deaths = 0
    @maps = 0
    @team = team
    @matches = Set.new
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
      100 * ((@kills + 0.8 * @assists) / (@kills + 0.8 * @assists + @deaths))
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
  
  def self.best_match_players(match)
    result = {}
    result[:kills] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(kills) desc').sum('kills').first
    result[:assists] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(assists) desc').sum('assists').first
    result[:deaths] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(deaths) asc').sum('deaths').first
    result
  end
end
