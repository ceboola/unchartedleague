class PlayerStats 
  def initialize(player)    
  end

  def self.best_match_players(match)
    result = {}
    result[:kills] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(kills) desc').sum('kills').first
    result[:assists] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(assists) desc').sum('assists').first
    result[:deaths] = MatchEntry.unscoped.where('match_id = ?', match.id).group('user_id').order('sum(deaths) asc').sum('deaths').first
    result
  end
end
