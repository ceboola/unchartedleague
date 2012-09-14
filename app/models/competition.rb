class Competition < ActiveRecord::Base
  belongs_to :parent_competition, :class_name => "Competition"
  has_many :teams, :through => :competition_entries
  has_many :competition_entries, :dependent => :destroy  
  has_many :competition_judges, :dependent => :destroy
  has_many :rounds
  has_many :matches
  
  validates :name, :presence => true
  
  accepts_nested_attributes_for :competition_entries, :allow_destroy => true
  accepts_nested_attributes_for :competition_judges, :allow_destroy => true
  
  def root
    c = self
    while c.parent_competition != nil
      c = c.parent_competition
    end
    c
  end
  
  # team
  def min_players
    6
  end
  
  # match
  def min_players_per_team
    4
  end
  
  def max_players_per_team
    5
  end
  
  def is_user_signed_up? (user)
    user_teams = Team.joins(:team_participations, :competition_entries).where("team_participations.user_id = ? and team_participations.active = ? and competition_id = ?", user.id, true, id)
    return !user_teams.empty?
  end
  
  def can_team_be_signed_up? (team)
    team.users.size >= min_players
  end
  
  def can_user_leave_team? (team)
    ends < DateTime.current or team.users.size > min_players
  end
  
  def get_judge
    judged_matches = {}
    for j in competition_judges
      judged_matches[j.user] = 0
    end
    
    for m in matches
      if  m.judge.present? and judged_matches.key? m.judge
        judged_matches[m.judge] += 1
      end
    end
    
    best = nil
    judged_matches.each do |judge, qty|
      if best.nil? or qty < judged_matches[best]
        best = judge
      end
    end
    
    return best
  end
  
  def to_s
    name
  end
  
  def long_name
    if parent_competition != nil
      "#{name} - #{parent_competition.long_name}"
    else
      "#{name} (sezon #{season})"     
    end
  end
  
  def stats_config
    { 
      :additional_matches => [],
      :seeded_teams => eval("{29 => 8, 30 => 7, 31 => 6, 12 => 5, 2 => 4, 22 => 3, 39 => 2, 8 => 1}"),
      :remove_forfeited => true,
      :show_place => true,
      :reject_conditions => ["x.matches < 3"],
      :sorting_condition => "[-x.priority, -x.per_match(x.points), -x.per_match(x.frags_diff), -x.per_match(x.frags_for)]",
      :fields => "['matches', 'points', 'wins', 'losses', 'frags_for', 'frags_against']",
      :additional_fields => {
        "Uwagi" => 'if x.priority > 0 then "rozstawiona" else "#{x.per_match(x.points)} pkt/mecz" end'
      }
    }
  end
end
