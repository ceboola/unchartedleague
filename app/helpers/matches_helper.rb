module MatchesHelper
  def match_teams(match)
    link_to(match.team1.name, match.team1) + " vs " + (match.open_spot? ? t('matches.open_spot') : (link_to match.team2.name, match.team2))
  end
end
