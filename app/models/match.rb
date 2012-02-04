class Match < ActiveRecord::Base
  belongs_to :competition
  belongs_to :team1, :class_name => "Team"
  belongs_to :team2, :class_name => "Team"
  belongs_to :judge, :class_name => "User"
  has_many :match_maps, :dependent => :destroy, :autosave => true
  has_many :maps, :through => :match_maps
  has_many :match_entries
  
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
    maps = Map.find_all_by_competition_id(competition.id, :select => "id").sort_by { rand }.slice(0...3)
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
      for match_map in match_maps
        if match_map.winning_team == team1
          team1wins += 1
        elsif match_map.winning_team == team2
          team2wins += 1
        end
      end
      team1wins.to_s + ":" + team2wins.to_s
    else
      "-:-"
    end
  end
  
  def detailed_result(user = nil)
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
  end
  
  def can_be_edited_by? (user)   
    ((!processed and judge == user) or (!processed and !locked_by_judge and (team1.has_member? user or team2.has_member? user)))
  end
end
