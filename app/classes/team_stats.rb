class TeamStats
  attr_accessor :team, :matches, :maps, :wins, :losses, :points, :frags_diff, :frags_for, :frags_against, :assists, :priority
  
  # initializes TeamStats object for given Team object
  #
  # +options+ hash should be passed to customize statistics: 
  # [competition] Competition object will be used to filter team stats to just this competition (default is nil)   
  # [remove_forfeited] true, if stats from forfeited matches should be omitted, false otherwise (default is false) 
  # [additional_matches] array of Match objects which should be additionally counted in the statistics (default is empty)
  # [priority] team priority value which can be used by ranking processor; priority != 0 means that the team is seeded (default is 0)
  def initialize(team, options = {})  
    @team = team
    competition = options[:competition]
    remove_forfeited = options[:remove_forfeited] || false    
    additional_matches_ids = options[:additional_matches_ids] || []
    @priority = options[:priority] || 0
    @points = 0
    if options[:starting_points].has_key? team.id
      @points = options[:starting_points][team.id]
    end

    matches_scoped =  Match.where('(team1_id = ? or team2_id = ?) and processed = ?', team.id, team.id, true).scoped
    if !competition.nil?
      matches_scoped = matches_scoped.where('competition_id = ?', competition.id).scoped
    end
    if remove_forfeited
      matches_scoped = matches_scoped.where('forfeiting_team_id is ?', nil)
    end

    matches_played = matches_scoped.all + additional_matches_ids.collect { |x| Match.find(x) }.reject { |x| x.team1 != team and x.team2 != team }     
        
    @matches = 0
    @maps = 0
    @wins = 0
    @losses = 0    
    @frags_for = 0
    @frags_against = 0
    @assists = 0
    for m in matches_played
      unless m.not_played?
        @matches += 1
        team1wins = 0
        team2wins = 0
        team1frags = 0
        team2frags = 0
        if m.forfeiting_team.nil?
          for match_map in m.match_maps
            if match_map.match_entries.any?
              @maps += 1
              if match_map.winning_team == m.team1
                team1wins += 1
              elsif match_map.winning_team == m.team2
                team2wins += 1
              end
              team1frags += match_map.team1score
              team2frags += match_map.team2score
            end
          end
        else
          @maps += 2
          if m.forfeiting_team == m.team1
            team2wins = 2
            team2frags = 50
          else
            team1wins = 2
            team1frags = 50
          end
        end
        if team1wins > team2wins
          if m.team1 == team
            @points += 3
            @wins += 1
          elsif team2wins > 0
            @points += 1        
            @losses += 1
          else
            @losses += 1
          end
        else
          if m.team2 == team
            @points += 3
            @wins += 1
          elsif team1wins > 0
            @points += 1        
            @losses += 1
          else
            @losses += 1
          end
        end

        if m.team1 == team
          @frags_for += team1frags
          @frags_against += team2frags
        else
          @frags_for += team2frags
          @frags_against += team1frags
        end
      end
    end
    
    @frags_diff = @frags_for - @frags_against
    # @assists = Match.joins(:match_maps).joins(:match_entries).where('team_id = ? and competition_id = ? and processed = ?', team.id, competition.id, true).sum('assists')
  end

  def per_match(attr)
    if @matches > 0
      return (attr / @matches.to_f).round(2)
    end
    return 0
  end
end
