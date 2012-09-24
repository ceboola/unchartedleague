module MatchesHelper
  def match_teams(match)
    link_to(name_with_award_image(match.team1), match.team1) + " vs " + (match.open_spot? ? t('matches.open_spot') : (link_to name_with_award_image(match.team2), match.team2))
  end
  
  def match_teams_without_awards(match)
    link_to(match.team1.to_s, match.team1) + " vs " + (match.open_spot? ? t('matches.open_spot') : (link_to match.team2.to_s, match.team2))
  end
  
  def match_teams_plain(match)
    match.team1.to_s + " vs " + (match.open_spot? ? t('matches.open_spot') : match.team2.to_s)
  end
end
