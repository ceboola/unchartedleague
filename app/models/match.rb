class Match < ActiveRecord::Base
  belongs_to :competition
  belongs_to :team1, :class_name => "Team"
  belongs_to :team2, :class_name => "Team"
  belongs_to :judge, :class_name => "User"
  belongs_to :forfeiting_team, :class_name => "Team"
  belongs_to :round
  has_many :match_maps, :dependent => :destroy, :autosave => true
  has_many :maps, :through => :match_maps
  has_many :match_entries
  has_many :match_time_proposals, :dependent => :destroy
  
  validates_associated :match_maps
  
  def self.filtered(user)
    unless user.nil?      
      ids = user.user_teams_ids
      Match.where('team1_id in (?) or team2_id in (?)', ids, ids)
    else
      Match.scoped
    end
  end
  
  def open_spot?
    team2.nil?
  end
  
  def generate_match_maps    
    maps = Map.select("id").sort_by { rand }.slice(0...3)
    for map in maps
      match_maps.build(:map_id => map.id)
    end
  end
  
  def teams
    [team1, team2]
  end
  
  def result
    if processed
      team1wins = 0
      team2wins = 0
      if forfeiting_team.nil?
        for match_map in match_maps
          if match_map.winning_team == team1
            team1wins += 1
          elsif match_map.winning_team == team2
            team2wins += 1
          end
        end
      else
        if forfeiting_team == team1
          team2wins = 2
        elsif forfeiting_team == team2
          team1wins = 2
        end
      end
      team1wins.to_s + ":" + team2wins.to_s
    else
      "-:-"
    end
  end

  def maps_won_by_team (team)
    wins = 0
    if forfeiting_team.nil?
      for match_map in match_maps
        if match_map.winning_team == team
          wins += 1
        end
      end    
    else
      if forfeiting_team != team
        wins = 2
      end
    end
  end

  def team_score_on_map (team, map)
    if forfeiting_team.nil?
      for match_map in match_maps
        if match_map.map == map
          if team == team1
            return match_map.team1score
          elsif team == team2
            return match_map.team2score
          end
        end
      end
    else
      if forfeiting_team == team
        0
      else
        25
      end
    end
    "-"
  end
  
  def detailed_result(user = nil)
    if forfeiting_team.nil?
      if processed or user == judge
        team1wins = 0
        team2wins = 0
        scores = []
        for match_map in match_maps
          if match_map.match_entries.any?
            if match_map.winning_team == team1
              team1wins += 1
            elsif match_map.winning_team == team2
              team2wins += 1
            end
            scores << match_map.team1score.to_s + "-" + match_map.team2score.to_s
          end
        end
        team1wins.to_s + ":" + team2wins.to_s + " (" + scores.join(', ') + ")"
      else
        result
      end
    else
      if forfeiting_team == team1
        "0:2 (0:25, 0:25)"
      else
        "2:0 (25:0, 25:0)"
      end
    end
  end
  
  def can_be_edited_by? (user)   
    ((!processed and judge == user) or (!processed and !locked_by_judge and (team1.has_member? user or team2.has_member? user)))
  end
end
