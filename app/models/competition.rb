class Competition < ActiveRecord::Base
  belongs_to :parent_competition, :class_name => "Competition"
  has_many :teams, :through => :competition_entries
  has_many :competition_entries, :dependent => :destroy
  has_many :rounds

  validates :name, :presence => true
  
  accepts_nested_attributes_for :competition_entries, :allow_destroy => true
  
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
  
  def to_s
    name
  end
  
  def long_name
    "#{name} (sezon #{season})"
  end
end
