class StatsController < ApplicationController
  def ranking
    @competitions = [Competition.find(3), Competition.find(4)]
    @stats = []
    for competition in @competitions
      stats = []
      for team in competition.teams
        stats << TeamStats.new(team, competition)
      end
      @stats[competition.id] = stats.sort_by { |x| [-x.points, -x.frags_diff, -x.frags_for] }
    end
  end
end
