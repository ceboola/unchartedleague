class HomeController < ApplicationController
  def index
    @competition = Competition.find(1)
    teams = Team.joins(:competition_entries).where('competition_entries.competition_id = ?', @competition.id).select('teams.id, tag, name')
    teams.sort! { |x, y| y.played_matches_size(@competition) <=> x.played_matches_size(@competition) }
    @teams_qualified = teams.select { |x| x.played_matches_size(@competition) >= 2}
    @teams_remaining = teams.select { |x| x.played_matches_size(@competition) < 2}
  end
end
