class Competition < ActiveRecord::Base
  has_many :teams, :through => :competition_entries
  has_many :competition_entries, :dependent => :destroy
  
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
    user_teams = Team.joins(:team_participations, :competition_entries).where("team_participations.user_id = ?", user.id)
    return !user_teams.empty?
  end
  
  def can_team_be_signed_up? (team)
    team.users.size >= min_players
  end
  
  def can_user_leave_team? (team)
    team.users.size > min_players
  end
  
  def to_s
    name
  end
end
