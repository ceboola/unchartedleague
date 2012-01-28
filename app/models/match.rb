class Match < ActiveRecord::Base
  belongs_to :competition
  belongs_to :team1, :class_name => "Team"
  belongs_to :team2, :class_name => "Team"
  belongs_to :judge, :class_name => "User"
  has_many :match_maps, :dependent => :destroy, :autosave => true
  has_many :maps, :through => :match_maps
  
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
  
  def result
    "-:-"
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
end
