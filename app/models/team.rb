class Team < ActiveRecord::Base
  has_many :users, :through => :team_participations
  has_many :team_participations, :dependent => :destroy
  has_many :offers, :dependent => :destroy
  has_many :competitions, :through => :competition_entries
  has_many :competition_entries, :dependent => :destroy
  has_many :awards, :dependent => :destroy
    
  validates :tag, :presence => true, :length => { :maximum => 4 }, :uniqueness => true
  validates :name, :presence => true, :length => { :maximum => 35 }, :uniqueness => true
  validates :description, :length => { :maximum => 250 }  
 
  paginates_per 20

  def played_matches_size(competition)
    Match.where('(team1_id = ? or team2_id = ?) and processed = ? and competition_id = ?', id, id, true, competition.id).count
  end
    
  def full_name
    "#{full_tag} #{name}"
  end
  
  def full_tag
    "[#{tag}]"
  end
  
  def can_be_managed_by?(user)
    for tp in team_participations
      if tp.is_owner?
        return user == tp.user
      end
    end
    return false
  end
  
  def members(filtered_roles = [])
    member_participations(filtered_roles).collect { |x| x.user }
  end
  
  def member_participations(filtered_roles = [])
    team_participations.select { |x| not filtered_roles.include? x.role }                       
  end
  
  def member_participation(member)
    team_participations.each do |tp|
      if tp.user == member
        return tp
      end
    end
    return nil
  end
  
  def has_member?(user)
    for tp in team_participations
      if tp.user == user
        return true
      end
    end
    return false
  end
  
  def owner_participation
    for tp in team_participations
      if tp.is_owner? and tp.active?
        return tp
      end
    end
    return nil
  end
  
  def owner
    unless owner_participation.nil? 
      owner_participation.user
    else
      nil
    end
  end
  
  def to_s
    name
  end
  
  def self.user_teams(user)
    unless user.nil?
      Team.joins(:team_participations).where('team_participations.user_id = ? and team_participations.active = ?', user.id, true)
    else
      Team.scoped
    end
  end
  
  def self.all_user_teams(user)
    unless user.nil?
      TeamParticipation.unscoped do
        Team.joins(:team_participations).where('team_participations.user_id = ?', user.id)
      end
    else
      Team.scoped
    end
  end

  def self.owned_by_user(user)
    unless user.nil?
      Team.joins(:team_participations).where('team_participations.user_id = ? and team_participations.role = ?', user.id, 0)
    else
      Team.scoped
    end
  end
  
  def member_count    
    Team.joins(:team_participations).where('teams.id = ?', id).count    
  end
  
  def all_users
    User.joins(:team_participations).where('team_participations.team_id = ?', id).order("active desc, role asc")
  end
end
