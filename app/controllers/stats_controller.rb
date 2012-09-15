class StatsController < ApplicationController
  def ranking
    @stats = {}
    @fields = {}
    @show_place = {}
    @starting_place = {}
    @competition = Competition.find(params[:competition_id])
    for competition in @competition.all_competitions
      stats = []
      for team in competition.teams
        priority = nil
        if competition.stats_config[:seeded_teams].has_key? team.id
          priority = competition.stats_config[:seeded_teams][team.id]
        end
        stats << TeamStats.new(team, :competition => competition, :additional_matches_ids => competition.stats_config[:additional_matches_ids], :remove_forfeited => competition.stats_config[:remove_forfeited], :priority => priority)
      end
      
      for rc in competition.stats_config[:reject_conditions]
        stats = stats.reject { |x| eval(rc) }
      end
      
      unless stats.empty?
        @stats[competition] = stats.sort_by { |x| eval(competition.stats_config[:sorting_condition]) }
        @fields[competition] = eval(competition.stats_config[:fields])
        @show_place[competition] = competition.stats_config[:show_place]
        @starting_place[competition] = competition.stats_config[:starting_place]
      end
    end
  end

  def players
    @stats = {}
    team_matches = {}
    for r in Competition.find(2).rounds
      for m in r.matches
        if m.has_valid_scores?
          for me in m.match_entries
            unless @stats.has_key? me.user.id
              @stats[me.user.id] = PlayerStats.new(me.user, me.team)
              unless team_matches.has_key? me.team
                team_matches[me.team] = Set.new
              end
            end
            @stats[me.user.id].kills += me.kills
            @stats[me.user.id].deaths += me.deaths
            @stats[me.user.id].assists += me.assists
            @stats[me.user.id].maps += 1
            @stats[me.user.id].matches << m           
            team_matches[me.team] << m
          end
        end
      end     
    end

    for stat in @stats.values
      stat.competition_activity = (100.0 * stat.matches.size / team_matches[stat.team].size)
    end

    @stats = @stats.values.sort_by { |x| [-x.skill, -x.kdr, -x.diff, -x.kills, -x.assists, x.deaths, -x.maps] }
  end
end
