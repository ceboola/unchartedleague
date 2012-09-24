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
        stats << TeamStats.new(team, :competition => competition, :starting_points => competition.stats_config[:starting_points], :additional_matches_ids => competition.stats_config[:additional_matches_ids], :remove_forfeited => competition.stats_config[:remove_forfeited], :priority => priority)
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
    @competition = Competition.find(params[:competition_id])
    @stats = {}
    team_matches = {} # FIXME: there's gotta be a better way
    
    for c in @competition.all_competitions
      for m in c.matches
        if m.has_valid_scores?
          if !team_matches.has_key? m.team1
            team_matches[m.team1] = 1
          else
            team_matches[m.team1] += 1
          end

          if !team_matches.has_key? m.team2
            team_matches[m.team2] = 1
          else
            team_matches[m.team2] += 1
          end

          for me in m.match_entries
            if !@stats.has_key? me.user
              @stats[me.user] = PlayerStats.new(me.user)              
            end
            @stats[me.user].add_match_entry me
          end
        end
      end
    end
    
    for v in @stats.values
      v.calculate_activity team_matches # FIXME: there's gotta be a better way
    end
    
    @stats = @stats.values.sort_by { |x| [-x.skill, -x.kdr, -x.diff, -x.kills, -x.assists, x.deaths, -x.maps] }
  end
end
